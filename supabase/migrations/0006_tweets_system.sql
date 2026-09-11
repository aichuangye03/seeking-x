-- ==========================================
-- 0006 Tweets System
-- Seeking-X
-- Purpose:
-- Create unified content storage table
-- ==========================================


-- 1. Create tweets table

create table if not exists public.tweets (

    id uuid primary key default gen_random_uuid(),


    -- source account
    account_id uuid not null
        references public.x_accounts(id)
        on delete cascade,


    -- original platform id
    external_id text not null,


    -- data source
    source text not null default 'x',


    -- original content
    content text,


    -- original url
    tweet_url text,


    -- language
    language text,


    -- original publish time
    published_at timestamptz,


    -- collector time
    collected_at timestamptz
        default now(),


    -- raw data from source
    raw_payload jsonb,


    -- engagement data
    engagement jsonb,


    -- AI processing status
    analysis_status text
        default 'pending'
        check (
            analysis_status in
            (
                'pending',
                'processing',
                'completed',
                'failed'
            )
        ),


    -- AI importance score
    importance_score integer
        check (
            importance_score >= 0
            and importance_score <= 100
        ),


    -- create time
    created_at timestamptz
        default now()

);



-- 2. Prevent duplicate tweets

create unique index if not exists tweets_external_id_unique
on public.tweets(external_id);



-- 3. Improve query speed

create index if not exists tweets_account_id_idx
on public.tweets(account_id);



create index if not exists tweets_published_at_idx
on public.tweets(published_at desc);



create index if not exists tweets_analysis_status_idx
on public.tweets(analysis_status);



-- 4. Enable RLS

alter table public.tweets
enable row level security;



-- 5. Admin/service role policy

create policy "service role can manage tweets"
on public.tweets
for all
to service_role
using (true)
with check (true);



-- 6. Authenticated users can read analyzed tweets

create policy "authenticated users can read tweets"
on public.tweets
for select
to authenticated
using (
    analysis_status = 'completed'
);
