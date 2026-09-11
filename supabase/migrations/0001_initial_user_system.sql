-- ============================================================
-- AI Investor Radar
-- Migration 0001
-- Initial User System
--
-- Creates:
--   1. public.profiles
--   2. public.user_settings
--   3. updated_at trigger
--   4. automatic profile/settings creation
--   5. admin security helper
--   6. Row Level Security policies
--
-- Authentication itself is handled by Supabase Auth:
--   auth.users
-- ============================================================


-- ============================================================
-- 1. Helper function: automatically update updated_at
-- ============================================================

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;


-- ============================================================
-- 2. profiles
-- ============================================================

create table public.profiles (
  id uuid primary key
    references auth.users(id)
    on delete cascade,

  display_name text,
  avatar_url text,

  role text not null default 'user'
    check (role in ('user', 'admin')),

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


-- ============================================================
-- 3. user_settings
-- ============================================================

create table public.user_settings (
  user_id uuid primary key
    references public.profiles(id)
    on delete cascade,

  timezone text not null default 'Asia/Shanghai',

  language text not null default 'zh-CN',

  daily_report_enabled boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


-- ============================================================
-- 4. updated_at triggers
-- ============================================================

create trigger profiles_set_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();


create trigger user_settings_set_updated_at
before update on public.user_settings
for each row
execute function public.set_updated_at();


-- ============================================================
-- 5. Admin helper
--
-- SECURITY DEFINER is used so the function can safely check
-- the user's role without being blocked by profiles RLS.
-- ============================================================

create or replace function public.is_admin()
returns boolean
language sql
security definer
stable
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'
  );
$$;


-- Only authenticated users need this helper.
revoke execute on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;


-- ============================================================
-- 6. Prevent ordinary users from changing their own role
--
-- Important:
-- RLS alone is not enough because an UPDATE policy could
-- accidentally allow a user to change role.
--
-- This trigger provides a second security boundary.
--
-- auth.uid() IS NULL is allowed for trusted server-side /
-- administrative SQL execution, such as initial admin setup.
-- ============================================================

create or replace function public.prevent_user_role_escalation()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin

  -- No authenticated identity means this is trusted
  -- server-side/database administration.
  if auth.uid() is null then
    return new;
  end if;

  -- The user is changing their own role.
  if auth.uid() = old.id
     and new.role is distinct from old.role then

    raise exception 'Users cannot change their own role';
  end if;

  -- A non-admin user cannot modify somebody else's role.
  if new.role is distinct from old.role
     and not public.is_admin() then

    raise exception 'Only administrators can change user roles';
  end if;

  return new;
end;
$$;


create trigger profiles_prevent_role_escalation
before update on public.profiles
for each row
execute function public.prevent_user_role_escalation();


-- ============================================================
-- 7. Automatically create profile + settings after signup
-- ============================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin

  insert into public.profiles (
    id,
    display_name,
    avatar_url,
    role
  )
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data ->> 'display_name',
      new.raw_user_meta_data ->> 'full_name'
    ),
    new.raw_user_meta_data ->> 'avatar_url',
    'user'
  );

  insert into public.user_settings (
    user_id
  )
  values (
    new.id
  );

  return new;
end;
$$;


create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_user();


-- ============================================================
-- 8. Enable Row Level Security
-- ============================================================

alter table public.profiles enable row level security;

alter table public.user_settings enable row level security;


-- ============================================================
-- 9. profiles RLS policies
-- ============================================================


-- Users can read their own profile.
create policy "Users can read their own profile"
on public.profiles
for select
to authenticated
using (
  auth.uid() = id
);


-- Admins can read all profiles.
create policy "Admins can read all profiles"
on public.profiles
for select
to authenticated
using (
  public.is_admin()
);


-- Users can update their own profile.
--
-- The trigger separately prevents role escalation.
create policy "Users can update their own profile"
on public.profiles
for update
to authenticated
using (
  auth.uid() = id
)
with check (
  auth.uid() = id
);


-- Admins can update profiles.
create policy "Admins can update profiles"
on public.profiles
for update
to authenticated
using (
  public.is_admin()
)
with check (
  public.is_admin()
);


-- ============================================================
-- 10. user_settings RLS policies
-- ============================================================


-- Users can read their own settings.
create policy "Users can read their own settings"
on public.user_settings
for select
to authenticated
using (
  auth.uid() = user_id
);


-- Users can update their own settings.
create policy "Users can update their own settings"
on public.user_settings
for update
to authenticated
using (
  auth.uid() = user_id
)
with check (
  auth.uid() = user_id
);


-- Admins can read all settings when necessary.
create policy "Admins can read all settings"
on public.user_settings
for select
to authenticated
using (
  public.is_admin()
);


-- ============================================================
-- 11. Explicitly prevent normal client-side INSERT/DELETE
--
-- Profiles and user_settings are created automatically.
-- They should not be freely created/deleted by clients.
--
-- DELETE is intentionally not exposed through application RLS.
-- Deleting auth.users will cascade to profiles and settings.
-- ============================================================
