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

drop function if exists "public"."refresh_conversation_members"(p_conversation_id bigint);

CREATE INDEX idx_conversation_members ON public.conversation USING gin (members);

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

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.update_conversation_members()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
    IF (OLD.name IS DISTINCT FROM NEW.name 
        OR OLD.avatar_url IS DISTINCT FROM NEW.avatar_url) THEN
        
        UPDATE public.conversation c
        SET members = COALESCE(
            (
                SELECT jsonb_agg(
                    CASE 
                        WHEN (elem->>'id')::uuid = NEW.id THEN 
                            elem || jsonb_build_object(
                                'name', NEW.name,
                                'avatar_url', NEW.avatar_url
                            )
                        ELSE elem
                    END
                )
                FROM jsonb_array_elements(c.members) AS elem
            ),
            '[]'::jsonb
        )
        WHERE EXISTS (
            SELECT 1
            FROM public.conversation_participants cp
            WHERE cp.conversation_id = c.id
              AND cp.user_id = NEW.id
        );
        
    END IF;

    RETURN NEW;
END;
$function$
;


  create policy "profile_update"
  on "public"."profiles"
  as permissive
  for update
  to authenticated
using ((auth.uid() = id))
with check ((auth.uid() = id));



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


CREATE TRIGGER trigger_update_conversation_members AFTER UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_conversation_members();

CREATE TRIGGER trigger_refresh_members AFTER INSERT OR DELETE ON public.conversation_participants FOR EACH ROW EXECUTE FUNCTION public.on_participant_change();

CREATE TRIGGER on_message_hard_delete AFTER DELETE ON public.message FOR EACH ROW EXECUTE FUNCTION public.handle_message_hard_delete();

CREATE TRIGGER on_message_insert AFTER INSERT ON public.message FOR EACH ROW EXECUTE FUNCTION public.handle_new_message();


  create policy "avatars_insert"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check ((bucket_id = 'avatars'::text));



  create policy "avatars_select"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'avatars'::text));



  create policy "avatars_update"
  on "storage"."objects"
  as permissive
  for update
  to authenticated
using ((bucket_id = 'avatars'::text));



  create policy "images_insert"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check ((bucket_id = 'images'::text));



  create policy "images_select"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'images'::text));



  create policy "images_update"
  on "storage"."objects"
  as permissive
  for update
  to authenticated
using ((bucket_id = 'images'::text));



