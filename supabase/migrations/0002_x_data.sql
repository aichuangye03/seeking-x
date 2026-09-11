-- =========================================================
-- 0002_x_data.sql
-- Phase 2: X public data layer
-- =========================================================

-- ---------------------------------------------------------
-- 1. X accounts
-- ---------------------------------------------------------

create table public.x_accounts (
  id uuid primary key default gen_random_uuid(),

  username text not null,
  display_name text,
  profile_url text,
  category text,
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint x_accounts_username_unique unique (username)
);

-- ---------------------------------------------------------
-- 2. Tweets
-- ---------------------------------------------------------

create table public.tweets (
  id uuid primary key default gen_random_uuid(),

  x_account_id uuid not null
    references public.x_accounts(id)
    on delete cascade,

  external_id text not null,
  text text not null,
  tweet_url text,
  published_at timestamptz,
  raw_payload jsonb,

  created_at timestamptz not null default now(),

  constraint tweets_external_id_unique unique (external_id)
);

-- ---------------------------------------------------------
-- 3. Indexes
-- ---------------------------------------------------------

create index x_accounts_is_active_idx
on public.x_accounts(is_active);

create index x_accounts_category_idx
on public.x_accounts(category);

create index tweets_x_account_id_idx
on public.tweets(x_account_id);

create index tweets_published_at_idx
on public.tweets(published_at desc);

-- ---------------------------------------------------------
-- 4. updated_at trigger
-- ---------------------------------------------------------

create trigger x_accounts_set_updated_at
before update on public.x_accounts
for each row execute function public.set_updated_at();

-- ---------------------------------------------------------
-- 5. Enable RLS
-- ---------------------------------------------------------

alter table public.x_accounts enable row level security;
alter table public.tweets enable row level security;

-- ---------------------------------------------------------
-- 6. Public read access
--
-- Guests and logged-in users can read public X data.
-- Only administrators will be allowed to modify it.
-- ---------------------------------------------------------

create policy "Anyone can read X accounts"
on public.x_accounts
for select
to anon, authenticated
using (true);

create policy "Anyone can read tweets"
on public.tweets
for select
to anon, authenticated
using (true);

-- ---------------------------------------------------------
-- 7. Admin write access
-- ---------------------------------------------------------

create policy "Admins can insert X accounts"
on public.x_accounts
for insert
to authenticated
with check (public.is_admin());

create policy "Admins can update X accounts"
on public.x_accounts
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy "Admins can delete X accounts"
on public.x_accounts
for delete
to authenticated
using (public.is_admin());

create policy "Admins can insert tweets"
on public.tweets
for insert
to authenticated
with check (public.is_admin());

create policy "Admins can update tweets"
on public.tweets
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy "Admins can delete tweets"
on public.tweets
for delete
to authenticated
using (public.is_admin());

-- ---------------------------------------------------------
-- End of migration
-- ---------------------------------------------------------
