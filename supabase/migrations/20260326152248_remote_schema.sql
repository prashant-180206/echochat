alter table "public"."conversation" drop constraint "conversation_last_message_fkey";

alter table "public"."message" add column "edited" boolean default false;

alter table "public"."message" add constraint "message_type_check" CHECK (((type)::text = ANY ((ARRAY['text'::character varying, 'image'::character varying, 'file'::character varying])::text[]))) not valid;

alter table "public"."message" validate constraint "message_type_check";

alter table "public"."conversation" add constraint "conversation_last_message_fkey" FOREIGN KEY (last_message) REFERENCES public.message(id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED not valid;

alter table "public"."conversation" validate constraint "conversation_last_message_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_message_hard_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  msg RECORD;
BEGIN
  -- Try to get latest remaining message
  SELECT id, created_at, content, type, sender_id
  INTO msg
  FROM message
  WHERE conversation_id = OLD.conversation_id
  ORDER BY created_at DESC, id DESC
  LIMIT 1;

  -- If no message found, reset conversation
  IF NOT FOUND THEN
    UPDATE conversation
    SET 
      last_message = NULL,
      last_time = conversation.created_at,
      last_message_content = 'New Conversation',
      last_message_type = 'text',
      last_message_sender_id = NULL
    WHERE id = OLD.conversation_id;

  ELSE
    -- Otherwise update with actual last message
    UPDATE conversation
    SET 
      last_message = msg.id,
      last_time = msg.created_at,
      last_message_content = msg.content,
      last_message_type = msg.type,
      last_message_sender_id = msg.sender_id
    WHERE id = OLD.conversation_id;

  END IF;

  RETURN NULL;
END;
$function$
;


  create policy "allow trigger update"
  on "public"."conversation"
  as permissive
  for update
  to public
using (true)
with check (true);



