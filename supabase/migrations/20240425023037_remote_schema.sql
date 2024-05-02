drop policy "Enable delete access for customers based on id" on "public"."customers";

drop policy "Enable insert for customers based on id" on "public"."customers";

drop policy "Enable read access for customers based on id" on "public"."customers";

drop policy "Enable update access for customers based on id" on "public"."customers";

drop policy "Enable delete access for subscriptions based on user_id" on "public"."subscriptions";

drop policy "Enable insert for subscriptions based on user_id" on "public"."subscriptions";

drop policy "Enable read access for subscriptions based on user_id" on "public"."subscriptions";

drop policy "Enable update access for subscriptions based on user_id" on "public"."subscriptions";

drop policy "Enable delete access for users based on id" on "public"."users";

drop policy "Enable insert for users based on id" on "public"."users";

drop policy "Enable read access for users based on id" on "public"."users";

drop policy "Enable update access for users based on id" on "public"."users";

alter table "public"."customers" drop constraint "customers_id_fkey";

alter table "public"."subscriptions" drop constraint "subscriptions_user_id_fkey";

alter table "public"."users" drop constraint "users_id_fkey";

alter type "public"."subscription_status" rename to "subscription_status__old_version_to_be_dropped";

create type "public"."subscription_status" as enum ('trialing', 'active', 'canceled', 'incomplete', 'incomplete_expired', 'past_due', 'unpaid');

alter table "public"."subscriptions" alter column status type "public"."subscription_status" using status::text::"public"."subscription_status";

drop type "public"."subscription_status__old_version_to_be_dropped";

alter table "public"."prices" add column "description" text;

alter table "public"."prices" add column "metadata" jsonb;

alter table "public"."customers" add constraint "customers_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) not valid;

alter table "public"."customers" validate constraint "customers_id_fkey";

alter table "public"."subscriptions" add constraint "subscriptions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) not valid;

alter table "public"."subscriptions" validate constraint "subscriptions_user_id_fkey";

alter table "public"."users" add constraint "users_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) not valid;

alter table "public"."users" validate constraint "users_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
  begin
    insert into public.users (id, full_name, avatar_url)
    values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
    return new;
  end;
$function$
;

create policy "Can update own user data."
on "public"."users"
as permissive
for update
to public
using ((auth.uid() = id));


create policy "Can view own user data."
on "public"."users"
as permissive
for select
to public
using ((auth.uid() = id));



