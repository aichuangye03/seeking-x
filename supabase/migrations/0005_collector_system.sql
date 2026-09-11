-- =========================================================
-- 0005_collector_system.sql
--
-- Purpose:
--   Create Collector management system.
--
-- Tables:
--   1. collector_runs
--      Record every collector execution.
--
--   2. collector_account_status
--      Track collection status for each X account.
--
-- Design principles:
--   - Collector is independent from data source.
--   - Supports Playwright / RSS / API / manual.
--   - Supports retry and failure tracking.
--   - Does not modify existing tables.
--
-- =========================================================


-- =========================================================
-- 1. Collector execution history
-- =========================================================

create table if not exists public.collector_runs (

    id uuid primary key default gen_random_uuid(),

    -- collector method
    -- playwright / rss / api / manual
    collector_type text not null default 'playwright',

    -- schedule source
    -- daily_morning / daily_evening / manual
    schedule_type text not null default 'manual',


    -- execution status
    -- running / success / partial_success / failed
    status text not null default 'running',


    started_at timestamptz not null default now(),

    finished_at timestamptz,


    -- target accounts
    accounts_target integer default 0,

    -- successfully collected accounts
    accounts_success integer default 0,


    -- tweet statistics
    tweets_found integer default 0,

    tweets_inserted integer default 0,


    -- error information
    error_message text,


    created_at timestamptz not null default now(),


    constraint collector_runs_status_check
    check (
        status in (
            'running',
            'success',
            'partial_success',
            'failed'
        )
    ),


    constraint collector_runs_type_check
    check (
        collector_type in (
            'playwright',
            'rss',
            'api',
            'manual'
        )
    ),


    constraint collector_runs_schedule_check
    check (
        schedule_type in (
            'daily_morning',
            'daily_evening',
            'manual'
        )
    )

);


-- =========================================================
-- 2. Account collection status
-- =========================================================

create table if not exists public.collector_account_status (

    id uuid primary key default gen_random_uuid(),


    -- link to monitored account
    account_id uuid not null
    references public.x_accounts(id)
    on delete cascade,


    -- latest collector run
    last_run_id uuid
    references public.collector_runs(id)
    on delete set null,


    -- timestamps

    last_attempt_at timestamptz,

    last_success_at timestamptz,


    -- latest tweet cursor
    -- used for incremental collection

    last_tweet_id text,


    -- statistics

    tweets_collected integer default 0,


    -- status

    status text not null default 'inactive',


    last_error_message text,


    created_at timestamptz not null default now(),

    updated_at timestamptz not null default now(),


    constraint collector_account_status_check
    check (
        status in (
            'success',
            'failed',
            'blocked',
            'inactive'
        )
    )


);


-- =========================================================
-- 3. Prevent duplicate account status
-- =========================================================

create unique index if not exists
collector_account_status_account_unique

on public.collector_account_status(account_id);



-- =========================================================
-- 4. Automatically create status records
--    for active X accounts
--
-- NOTE:
-- We only create records when running manually.
-- No trigger here.
-- Avoid hidden database behavior.
-- =========================================================



-- =========================================================
-- 5. Indexes
-- =========================================================


create index if not exists
collector_runs_created_at_idx

on public.collector_runs(created_at desc);



create index if not exists
collector_runs_status_idx

on public.collector_runs(status);



create index if not exists
collector_account_status_status_idx

on public.collector_account_status(status);



create index if not exists
collector_account_status_success_time_idx

on public.collector_account_status(last_success_at);



-- =========================================================
-- Migration completed
-- =========================================================
