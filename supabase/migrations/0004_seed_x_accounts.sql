-- =========================================================
-- 0004_seed_x_accounts.sql
-- Phase 2: Seed first batch of high-value X accounts
--
-- Purpose:
--   Seed the first 49 verified/high-value X accounts.
--
-- Notes:
--   - usernames are normalized without "@"
--   - usernames are lowercase
--   - priority:
--       1 = highest investment value
--       2 = important industry/source
--       3 = auxiliary
--   - monitor_level:
--       core      = full monitoring + AI analysis
--       industry  = important industry/company events
--       auxiliary = anomaly/keyword triggered
--
-- This migration does NOT:
--   - create tables
--   - modify RLS
--   - create users
--   - create tweets
-- =========================================================


insert into public.x_accounts (
  username,
  display_name,
  profile_url,
  category,
  priority,
  is_official,
  monitor_level,
  is_active
)
values

-- =========================================================
-- A. Core investment / semiconductor / AI infrastructure
-- =========================================================

(
  'semianalysis_',
  'SemiAnalysis',
  'https://x.com/SemiAnalysis_',
  'semiconductor',
  1,
  false,
  'core',
  true
),

(
  'dylan522p',
  'Dylan Patel',
  'https://x.com/dylan522p',
  'datacenter',
  1,
  false,
  'core',
  true
),

(
  'skundojjala',
  'SK',
  'https://x.com/SKundojjala',
  'semiconductor',
  1,
  false,
  'core',
  true
),

(
  'aleabitoreddit',
  'Serenity',
  'https://x.com/aleabitoreddit',
  'semiconductor',
  1,
  false,
  'core',
  true
),

(
  'srasgon',
  'Stacy Rasgon',
  'https://x.com/Srasgon',
  'semiconductor',
  1,
  false,
  'core',
  true
),

(
  'beth_kindig',
  'Beth Kindig',
  'https://x.com/Beth_Kindig',
  'ai',
  1,
  false,
  'core',
  true
),

(
  'danieltniles',
  'Daniel Niles',
  'https://x.com/DanielTNiles',
  'market',
  1,
  false,
  'core',
  true
),

(
  'citrini',
  'Citrini',
  'https://x.com/citrini',
  'market',
  1,
  false,
  'core',
  true
),

(
  'andrewlekashman',
  'Andrew Leckashman',
  'https://x.com/andrewlekashman',
  'semiconductor',
  1,
  false,
  'core',
  true
),

(
  'mingchikuo',
  'Ming-Chi Kuo',
  'https://x.com/mingchikuo',
  'consumer_electronics',
  1,
  false,
  'core',
  true
),

(
  'lightcounting',
  'LightCounting',
  'https://x.com/lightcounting',
  'optical',
  1,
  false,
  'core',
  true
),

(
  'semivision_tw',
  'SemiVision',
  'https://x.com/semivision_tw',
  'semiconductor',
  1,
  false,
  'core',
  true
),

(
  'semiconductorsx',
  'SemiconductorsX',
  'https://x.com/SemiconductorsX',
  'semiconductor',
  1,
  false,
  'core',
  true
),

(
  'universeice',
  'Ice universe',
  'https://x.com/UniverseIce',
  'consumer_electronics',
  2,
  false,
  'industry',
  true
),

-- =========================================================
-- B. Optical / semiconductor / AI infrastructure companies
-- =========================================================

(
  'lumentum',
  'Lumentum',
  'https://x.com/Lumentum',
  'optical',
  1,
  true,
  'industry',
  true
),

(
  'coherentcorp',
  'Coherent',
  'https://x.com/CoherentCorp',
  'optical',
  1,
  true,
  'industry',
  true
),

(
  'nvidia',
  'NVIDIA',
  'https://x.com/nvidia',
  'semiconductor',
  1,
  true,
  'industry',
  true
),

(
  'amd',
  'AMD',
  'https://x.com/AMD',
  'semiconductor',
  1,
  true,
  'industry',
  true
),

(
  'jensenhuang',
  'Jensen Huang',
  'https://x.com/JensenHuang',
  'ai',
  1,
  false,
  'industry',
  true
),

(
  'openai',
  'OpenAI',
  'https://x.com/OpenAI',
  'ai',
  1,
  true,
  'industry',
  true
),

(
  'anthropicai',
  'Anthropic',
  'https://x.com/AnthropicAI',
  'ai',
  1,
  true,
  'industry',
  true
),

(
  'googledeepmind',
  'Google DeepMind',
  'https://x.com/GoogleDeepMind',
  'ai',
  1,
  true,
  'industry',
  true
),

(
  'meta',
  'Meta',
  'https://x.com/Meta',
  'datacenter',
  1,
  true,
  'industry',
  true
),

(
  'cerebras',
  'Cerebras',
  'https://x.com/cerebras',
  'ai',
  2,
  true,
  'industry',
  true
),

(
  'isomorphiclabs',
  'Isomorphic Labs',
  'https://x.com/IsomorphicLabs',
  'biotech',
  2,
  true,
  'industry',
  true
),

-- =========================================================
-- C. AI researchers / technology trend sources
-- =========================================================

(
  'karpathy',
  'Andrej Karpathy',
  'https://x.com/karpathy',
  'ai',
  1,
  false,
  'industry',
  true
),

(
  'fchollet',
  'François Chollet',
  'https://x.com/fchollet',
  'ai',
  1,
  false,
  'industry',
  true
),

(
  'swyx',
  'swyx',
  'https://x.com/swyx',
  'software',
  2,
  false,
  'industry',
  true
),

(
  'emollick',
  'Ethan Mollick',
  'https://x.com/emollick',
  'ai',
  2,
  false,
  'industry',
  true
),

(
  'andrewyng',
  'Andrew Ng',
  'https://x.com/AndrewYNg',
  'ai',
  2,
  false,
  'industry',
  true
),

(
  'lilianweng',
  'Lilian Weng',
  'https://x.com/lilianweng',
  'ai',
  1,
  false,
  'industry',
  true
),

(
  'hwchase17',
  'Harrison Chase',
  'https://x.com/hwchase17',
  'ai',
  2,
  false,
  'industry',
  true
),

(
  'langchain',
  'LangChain',
  'https://x.com/LangChain',
  'software',
  2,
  true,
  'industry',
  true
),

(
  'darioamodei',
  'Dario Amodei',
  'https://x.com/DarioAmodei',
  'ai',
  1,
  false,
  'industry',
  true
),

(
  'demishassabis',
  'Demis Hassabis',
  'https://x.com/demishassabis',
  'ai',
  1,
  false,
  'industry',
  true
),

(
  'huggingface',
  'Hugging Face',
  'https://x.com/HuggingFace',
  'ai',
  2,
  true,
  'industry',
  true
),

(
  'gradio',
  'Gradio',
  'https://x.com/Gradio',
  'software',
  3,
  true,
  'industry',
  true
),

(
  'cognition',
  'Cognition',
  'https://x.com/cognition',
  'ai',
  2,
  true,
  'industry',
  true
),

(
  'steipete',
  'Peter Steinberger',
  'https://x.com/steipete',
  'software',
  2,
  false,
  'industry',
  true
),

-- =========================================================
-- D. Macro / market / Fed / global market intelligence
-- =========================================================

(
  'lizannsunders',
  'Liz Ann Sonders',
  'https://x.com/LizAnnSonders',
  'macro',
  1,
  false,
  'core',
  true
),

(
  'nicktimiraos',
  'Nick Timiraos',
  'https://x.com/NickTimiraos',
  'macro',
  1,
  false,
  'core',
  true
),

(
  'kobeissiletter',
  'The Kobeissi Letter',
  'https://x.com/KobeissiLetter',
  'macro',
  1,
  false,
  'core',
  true
),

(
  'firstsquawk',
  'First Squawk',
  'https://x.com/FirstSquawk',
  'market',
  1,
  false,
  'core',
  true
),

(
  'ft',
  'Financial Times',
  'https://x.com/FT',
  'macro',
  2,
  true,
  'industry',
  true
),

(
  'marketwatch',
  'MarketWatch',
  'https://x.com/MarketWatch',
  'market',
  2,
  true,
  'industry',
  true
),

(
  'scottwapnercnbc',
  'Scott Wapner',
  'https://x.com/ScottWapnerCNBC',
  'market',
  2,
  false,
  'industry',
  true
),

(
  'cnbcclosingbell',
  'CNBC Closing Bell',
  'https://x.com/CNBCClosingBell',
  'market',
  2,
  true,
  'industry',
  true
),

-- =========================================================
-- E. Biotechnology
-- =========================================================

(
  'statnews',
  'STAT',
  'https://x.com/statnews',
  'biotech',
  2,
  true,
  'industry',
  true
),

(
  'adamfeuerstein',
  'Adam Feuerstein',
  'https://x.com/adamfeuerstein',
  'biotech',
  1,
  false,
  'core',
  true
)

on conflict do nothing;
