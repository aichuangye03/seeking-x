-- ==========================================
-- 0007 Upgrade Tweets System
-- Upgrade existing tweets table
-- ==========================================


-- 1. Rename old columns


alter table public.tweets
rename column x_account_id
to account_id;


alter table public.tweets
rename column text
to content;



-- 2. Add new columns


alter table public.tweets
add column if not exists source text
default 'x';



alter table public.tweets
add column if not exists language text;



alter table public.tweets
add column if not exists collected_at timestamptz
default now();



alter table public.tweets
add column if not exists engagement jsonb;



alter table public.tweets
add column if not exists analysis_status text
default 'pending';



alter table public.tweets
add column if not exists importance_score integer;



-- 3. Add constraints


alter table public.tweets
add constraint tweets_analysis_status_check
check (
analysis_status in
(
'pending',
'processing',
'completed',
'failed'
)
);



alter table public.tweets
add constraint tweets_importance_score_check
check (
importance_score >=0
and importance_score <=100
);



-- 4. Ensure foreign key


alter table public.tweets
add constraint tweets_account_id_fkey
foreign key(account_id)
references public.x_accounts(id)
on delete cascade;



-- 5. Unique external id


create unique index if not exists tweets_external_id_unique
on public.tweets(external_id);



-- 6. Indexes


create index if not exists tweets_account_id_idx
on public.tweets(account_id);



create index if not exists tweets_published_at_idx
on public.tweets(published_at desc);



create index if not exists tweets_analysis_status_idx
on public.tweets(analysis_status);



-- 7. Enable RLS

alter table public.tweets
enable row level security;



-- 8. Service role access

create policy "service role manage tweets"
on public.tweets
for all
to service_role
using(true)
with check(true);



-- 9. Authenticated users read completed analysis

create policy "authenticated read analyzed tweets"
on public.tweets
for select
to authenticated
using(
analysis_status='completed'
);
