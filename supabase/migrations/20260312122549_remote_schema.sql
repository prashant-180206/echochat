

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

COMMENT ON SCHEMA "public" IS 'standard public schema';

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

CREATE OR REPLACE FUNCTION "public"."create_new_conversation"("other_user_id" "uuid") RETURNS bigint
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  existing_convo_id bigint;
  new_convo_id bigint;
BEGIN
  -- 1. Check if a conversation already exists between these two users
  SELECT cp1.conversation_id INTO existing_convo_id
  FROM public.conversation_participants cp1
  INNER JOIN public.conversation_participants cp2 
    ON cp1.conversation_id = cp2.conversation_id
  WHERE cp1.user_id = auth.uid() 
    AND cp2.user_id = other_user_id
  LIMIT 1;

  -- 2. If it exists, return that ID and stop
  IF existing_convo_id IS NOT NULL THEN
    RETURN existing_convo_id;
  END IF;

  -- 3. Otherwise, create a new one (Atomic Transaction)
  INSERT INTO public.conversation (last_message_content, last_time)
  VALUES ('New conversation started', now())
  RETURNING id INTO new_convo_id;

  -- Add the current user
  INSERT INTO public.conversation_participants (conversation_id, user_id)
  VALUES (new_convo_id, auth.uid());

  -- Add the other user
  INSERT INTO public.conversation_participants (conversation_id, user_id)
  VALUES (new_convo_id, other_user_id);

  RETURN new_convo_id;
END;
$$;

ALTER FUNCTION "public"."create_new_conversation"("other_user_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."get_my_conversations"() RETURNS SETOF bigint
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
  SELECT conversation_id 
  FROM public.conversation_participants 
  WHERE user_id = auth.uid();
$$;

ALTER FUNCTION "public"."get_my_conversations"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_message_hard_delete"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  new_last_message bigint;
BEGIN
  IF OLD.id = (
    SELECT last_message FROM conversation
    WHERE id = OLD.conversation_id
  ) THEN

    SELECT id INTO new_last_message
    FROM message
    WHERE conversation_id = OLD.conversation_id
    ORDER BY created_at DESC
    LIMIT 1;

    UPDATE conversation
    SET last_message = new_last_message,
        last_time = COALESCE(
          (SELECT created_at FROM message WHERE id = new_last_message),
          conversation.created_at
        )
    WHERE id = OLD.conversation_id;

  END IF;

  RETURN OLD;
END;
$$;

ALTER FUNCTION "public"."handle_message_hard_delete"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_new_message"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  UPDATE public.conversation
  SET 
    last_message = NEW.id,
    last_time = NEW.created_at,
    last_message_content = NEW.content,
    last_message_type = NEW.type,
    last_message_sender_id = NEW.sender_id,
    unread = unread + 1 -- Automatically increment unread
  WHERE id = NEW.conversation_id;
  
  RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."handle_new_message"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."on_participant_change"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- If a member is added, refresh that conversation's member list
  IF (TG_OP = 'INSERT') THEN
    PERFORM public.refresh_conversation_members(NEW.conversation_id);
  -- If a member is removed, refresh using the OLD ID
  ELSIF (TG_OP = 'DELETE') THEN
    PERFORM public.refresh_conversation_members(OLD.conversation_id);
  END IF;
  RETURN NULL;
END;
$$;

ALTER FUNCTION "public"."on_participant_change"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."refresh_conversation_members"("p_conversation_id" bigint) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  UPDATE public.conversation
  SET members = (
    SELECT jsonb_agg(jsonb_build_object('id', p.id, 'name', p.name, 'avatar_url', p.avatar_url))
    FROM public.conversation_participants cp
    JOIN public.profiles p ON cp.user_id = p.id
    WHERE cp.conversation_id = p_conversation_id
  )
  WHERE id = p_conversation_id;
END;
$$;

ALTER FUNCTION "public"."refresh_conversation_members"("p_conversation_id" bigint) OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."conversation" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "unread" integer DEFAULT 0,
    "last_time" timestamp with time zone DEFAULT "now"(),
    "last_message_content" "text" DEFAULT 'New Conversation'::"text" NOT NULL,
    "last_message_type" character varying DEFAULT 'text'::character varying,
    "last_message_sender_id" "uuid",
    "members" "jsonb" DEFAULT '[]'::"jsonb",
    "last_message" bigint
);

ALTER TABLE "public"."conversation" OWNER TO "postgres";

COMMENT ON TABLE "public"."conversation" IS 'stores conversation Data';

ALTER TABLE "public"."conversation" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."conversation_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."conversation_participants" (
    "user_id" "uuid" NOT NULL,
    "conversation_id" bigint NOT NULL
);

ALTER TABLE "public"."conversation_participants" OWNER TO "postgres";

COMMENT ON TABLE "public"."conversation_participants" IS 'Conversations and participants';

CREATE TABLE IF NOT EXISTS "public"."message" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "content" "text" DEFAULT ''::"text",
    "type" character varying DEFAULT '"text"'::character varying,
    "sender_id" "uuid" NOT NULL,
    "conversation_id" bigint
);

ALTER TABLE "public"."message" OWNER TO "postgres";

COMMENT ON TABLE "public"."message" IS 'store messages for chat app';

ALTER TABLE "public"."message" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."message_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "email" character varying DEFAULT ''::character varying,
    "bio" "text" DEFAULT ''::"text",
    "gender" character varying DEFAULT ''::character varying,
    "avatar_url" character varying DEFAULT ''::character varying,
    "name" "text"
);

ALTER TABLE "public"."profiles" OWNER TO "postgres";

COMMENT ON TABLE "public"."profiles" IS 'store Users and their data';

COMMENT ON COLUMN "public"."profiles"."name" IS 'Name of the User';

ALTER TABLE ONLY "public"."conversation_participants"
    ADD CONSTRAINT "conversation_participants_pkey" PRIMARY KEY ("user_id", "conversation_id");

ALTER TABLE ONLY "public"."conversation"
    ADD CONSTRAINT "conversation_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."message"
    ADD CONSTRAINT "message_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "user_pkey" PRIMARY KEY ("id");

CREATE INDEX "idx_message_conversation" ON "public"."message" USING "btree" ("conversation_id");

CREATE INDEX "idx_message_created_at" ON "public"."message" USING "btree" ("created_at");

CREATE OR REPLACE TRIGGER "on_message_hard_delete" AFTER DELETE ON "public"."message" FOR EACH ROW EXECUTE FUNCTION "public"."handle_message_hard_delete"();

CREATE OR REPLACE TRIGGER "on_message_insert" AFTER INSERT ON "public"."message" FOR EACH ROW EXECUTE FUNCTION "public"."handle_new_message"();

CREATE OR REPLACE TRIGGER "trigger_refresh_members" AFTER INSERT OR DELETE ON "public"."conversation_participants" FOR EACH ROW EXECUTE FUNCTION "public"."on_participant_change"();

ALTER TABLE ONLY "public"."conversation"
    ADD CONSTRAINT "conversation_last_message_fkey" FOREIGN KEY ("last_message") REFERENCES "public"."message"("id");

ALTER TABLE ONLY "public"."conversation_participants"
    ADD CONSTRAINT "conversation_participants_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "public"."conversation"("id");

ALTER TABLE ONLY "public"."conversation_participants"
    ADD CONSTRAINT "conversation_participants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id");

ALTER TABLE ONLY "public"."message"
    ADD CONSTRAINT "message_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "public"."conversation"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."message"
    ADD CONSTRAINT "message_sender_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "user_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id");

CREATE POLICY "Profiles are viewable by everyone" ON "public"."profiles" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Users can add participants" ON "public"."conversation_participants" FOR INSERT TO "authenticated" WITH CHECK (true);

CREATE POLICY "Users can create conversations" ON "public"."conversation" FOR INSERT TO "authenticated" WITH CHECK (true);

CREATE POLICY "Users can insert their own profile" ON "public"."profiles" FOR INSERT WITH CHECK (("auth"."uid"() = "id"));

CREATE POLICY "Users can see their own conversations" ON "public"."conversation" FOR SELECT USING (("id" IN ( SELECT "public"."get_my_conversations"() AS "get_my_conversations")));

CREATE POLICY "Users can select their own profile" ON "public"."profiles" FOR SELECT USING (("auth"."uid"() = "id"));

CREATE POLICY "Users can view participants in their chats" ON "public"."conversation_participants" FOR SELECT USING (("conversation_id" IN ( SELECT "public"."get_my_conversations"() AS "get_my_conversations")));

ALTER TABLE "public"."conversation" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."conversation_participants" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "crud on message only by authenticated users" ON "public"."message" USING (("auth"."uid"() IS NOT NULL)) WITH CHECK (("auth"."uid"() IS NOT NULL));

ALTER TABLE "public"."message" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;

ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."conversation";

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."message";

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON FUNCTION "public"."create_new_conversation"("other_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."create_new_conversation"("other_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_new_conversation"("other_user_id" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."get_my_conversations"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_my_conversations"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_my_conversations"() TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_message_hard_delete"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_message_hard_delete"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_message_hard_delete"() TO "service_role";

GRANT ALL ON FUNCTION "public"."handle_new_message"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_message"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_message"() TO "service_role";

GRANT ALL ON FUNCTION "public"."on_participant_change"() TO "anon";
GRANT ALL ON FUNCTION "public"."on_participant_change"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."on_participant_change"() TO "service_role";

GRANT ALL ON FUNCTION "public"."refresh_conversation_members"("p_conversation_id" bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."refresh_conversation_members"("p_conversation_id" bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."refresh_conversation_members"("p_conversation_id" bigint) TO "service_role";

GRANT ALL ON TABLE "public"."conversation" TO "anon";
GRANT ALL ON TABLE "public"."conversation" TO "authenticated";
GRANT ALL ON TABLE "public"."conversation" TO "service_role";

GRANT ALL ON SEQUENCE "public"."conversation_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."conversation_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."conversation_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."conversation_participants" TO "anon";
GRANT ALL ON TABLE "public"."conversation_participants" TO "authenticated";
GRANT ALL ON TABLE "public"."conversation_participants" TO "service_role";

GRANT ALL ON TABLE "public"."message" TO "anon";
GRANT ALL ON TABLE "public"."message" TO "authenticated";
GRANT ALL ON TABLE "public"."message" TO "service_role";

GRANT ALL ON SEQUENCE "public"."message_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."message_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."message_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";

drop extension if exists "pg_net";

drop trigger if exists "trigger_refresh_members" on "public"."conversation_participants";

drop trigger if exists "on_message_hard_delete" on "public"."message";

drop trigger if exists "on_message_insert" on "public"."message";

drop policy "Users can see their own conversations" on "public"."conversation";

drop policy "Users can view participants in their chats" on "public"."conversation_participants";

alter table "public"."conversation" drop constraint "conversation_last_message_fkey";

alter table "public"."conversation_participants" drop constraint "conversation_participants_conversation_id_fkey";

alter table "public"."conversation_participants" drop constraint "conversation_participants_user_id_fkey";

alter table "public"."message" drop constraint "message_conversation_id_fkey";

alter table "public"."message" drop constraint "message_sender_fkey";

alter table "public"."conversation" add constraint "conversation_last_message_fkey" FOREIGN KEY (last_message) REFERENCES public.message(id) not valid;

alter table "public"."conversation" validate constraint "conversation_last_message_fkey";

alter table "public"."conversation_participants" add constraint "conversation_participants_conversation_id_fkey" FOREIGN KEY (conversation_id) REFERENCES public.conversation(id) not valid;

alter table "public"."conversation_participants" validate constraint "conversation_participants_conversation_id_fkey";

alter table "public"."conversation_participants" add constraint "conversation_participants_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.profiles(id) not valid;

alter table "public"."conversation_participants" validate constraint "conversation_participants_user_id_fkey";

alter table "public"."message" add constraint "message_conversation_id_fkey" FOREIGN KEY (conversation_id) REFERENCES public.conversation(id) ON DELETE CASCADE not valid;

alter table "public"."message" validate constraint "message_conversation_id_fkey";

alter table "public"."message" add constraint "message_sender_fkey" FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;

alter table "public"."message" validate constraint "message_sender_fkey";

  create policy "Users can see their own conversations"
  on "public"."conversation"
  as permissive
  for select
  to public
using ((id IN ( SELECT public.get_my_conversations() AS get_my_conversations)));

  create policy "Users can view participants in their chats"
  on "public"."conversation_participants"
  as permissive
  for select
  to public
using ((conversation_id IN ( SELECT public.get_my_conversations() AS get_my_conversations)));

CREATE TRIGGER trigger_refresh_members AFTER INSERT OR DELETE ON public.conversation_participants FOR EACH ROW EXECUTE FUNCTION public.on_participant_change();

CREATE TRIGGER on_message_hard_delete AFTER DELETE ON public.message FOR EACH ROW EXECUTE FUNCTION public.handle_message_hard_delete();

CREATE TRIGGER on_message_insert AFTER INSERT ON public.message FOR EACH ROW EXECUTE FUNCTION public.handle_new_message();

