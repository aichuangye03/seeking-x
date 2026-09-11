-- =========================================================
-- 0003_x_account_management.sql
-- Phase 2: X account management
-- =========================================================

-- ---------------------------------------------------------
-- 1. Add account management fields
-- ---------------------------------------------------------

alter table public.x_accounts
add column priority smallint not null default 2
  check (priority between 1 and 3);

alter table public.x_accounts
add column is_official boolean not null default false;

alter table public.x_accounts
add column monitor_level text not null default 'industry'
  check (monitor_level in ('core', 'industry', 'auxiliary'));

-- ---------------------------------------------------------
-- 2. Normalize existing usernames
--
-- Standard format:
-- - remove leading @
-- - convert to lowercase
-- ---------------------------------------------------------

update public.x_accounts
set username = lower(
  regexp_replace(username, '^@', '')
);

-- ---------------------------------------------------------
-- 3. Replace the old case-sensitive unique constraint
--    with a case-insensitive unique index.
-- ---------------------------------------------------------

alter table public.x_accounts
drop constraint x_accounts_username_unique;

create unique index x_accounts_username_lower_unique
on public.x_accounts (lower(username));

-- ---------------------------------------------------------
-- 4. Additional indexes
-- ---------------------------------------------------------

create index x_accounts_priority_idx
on public.x_accounts(priority);

create index x_accounts_monitor_level_idx
on public.x_accounts(monitor_level);

create index x_accounts_official_idx
on public.x_accounts(is_official);

-- ---------------------------------------------------------
-- 5. Prevent invalid username values
-- ---------------------------------------------------------

alter table public.x_accounts
add constraint x_accounts_username_not_empty
check (length(trim(username)) > 0);

-- ---------------------------------------------------------
-- End of migration
-- ---------------------------------------------------------
