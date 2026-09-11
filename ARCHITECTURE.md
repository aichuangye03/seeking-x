# AI Investor Radar

## 1. Project Purpose

AI Investor Radar is an investment intelligence system designed to collect,
normalize, analyze, and present public investment information.

The initial data sources include:

- X / Twitter public accounts
- Seeking Alpha
- Public company information
- Public market information

The system will extract investment viewpoints, identify changes in opinions,
connect information with companies and securities, and generate investment
research reports.

---

## 2. Core Architecture Principle

The system must separate:

1. Public investment intelligence data
2. User-specific data

Public investment intelligence is shared across all users.

The same X post, article, or AI analysis must not be duplicated for different
users.

User-specific features such as favorites, reading history, personal settings,
and future personalized monitoring are stored separately.

---

## 3. No Mandatory Paid Third-Party Dependency

The core system must NOT depend on any mandatory paid third-party service.

This means the core architecture must not require:

- Paid X/Twitter API
- Paid X/Twitter scraper
- Paid RSS service
- Paid web scraping platform
- Paid automation platform
- Paid data aggregation platform
- Any other mandatory paid external infrastructure

External services may be used only when they are replaceable and are not a
hard dependency of the core system.

The system must remain operational if an external provider is replaced.

---

## 4. Data Ownership

Core data should be stored under the project's own control.

Raw source data should be preserved whenever practical.

AI-generated analysis must not replace the original source content.

The system should support re-analysis of historical source data using a
different AI model or prompt version.

---

## 5. Replaceable Data Collectors

Data collection must use a replaceable collector architecture.

Conceptually:

Source
    ↓
Collector
    ↓
Normalized Data
    ↓
Database

The database and analysis layer must not depend on one specific X/Twitter
collection provider.

If a collector becomes unavailable, changes its API, or becomes paid,
another collector must be replaceable without redesigning the database.

---

## 6. Replaceable AI Providers

AI analysis must use a provider-independent architecture.

Conceptually:

Raw Data
    ↓
AI Analyzer Interface
    ↓
AI Provider
    ↓
Analysis Result

The system must not hard-code core business logic to one AI provider.

Possible providers may include OpenAI, Gemini, or other compatible providers.

AI model name and prompt version should be stored with analysis results.

---

## 7. Frontend Architecture

The initial frontend may be built with Lovable.

However, Lovable must not become the core backend.

The frontend is a client of the backend/data layer.

The architecture must remain compatible with:

- Web
- Future mobile APP
- Future WeChat Mini Program

Business logic and data access should therefore remain independent from the
frontend.

---

## 8. Technology Direction

Preferred technology stack:

Frontend:
React + TypeScript

Backend:
TypeScript

Database:
Supabase PostgreSQL

Authentication:
Supabase Auth

The project should prefer a small number of standard technologies and avoid
unnecessary dependencies.

---

## 9. Authentication

The first authentication method is:

Email + Password

Supabase Auth manages authentication credentials.

Business profile information is stored separately in:

public.profiles

Future phone verification / phone login may be added without redesigning the
core user model.

---

## 10. User Roles

The initial system has only two roles:

- user
- admin

Users cannot promote themselves to admin.

Role permissions must be enforced at the database level.

The frontend must never be treated as the primary security boundary.

---

## 11. Permission Model

Guest:
- Read public content when the product permits public browsing.

User:
- Read public investment intelligence.
- Manage their own profile.
- Manage their own settings.
- Use future personal features.

Admin:
- All normal user capabilities.
- Manage public investment content.
- Manage system configuration.
- Manage monitored public sources.

Ordinary users must not modify public investment intelligence.

---

## 12. Database Security

Supabase Row Level Security (RLS) must be enabled for application tables
where access control is required.

User-specific data must normally be restricted using auth.uid().

Users must not be able to read or modify another user's private data.

Administrative operations must be protected by database-level permissions.

---

## 13. Public Data Model

Public investment intelligence will eventually include entities such as:

- x_accounts
- tweets
- sa_sources
- sa_articles
- ai_analyses
- securities
- daily_reports

These are shared public data.

They should not be duplicated per user.

---

## 14. Future Personalization

The initial frontend uses the shared public investment intelligence model.

Future personalization may add relationships such as:

- user_x_accounts
- user_securities
- user_topics
- user_report_settings
- favorites
- reading_history

These tables should reference shared public data rather than duplicate it.

This preserves the possibility of a future personalized investment radar.

---

## 15. Raw Data Preservation

Whenever practical, original source information should be preserved.

For example:

X post
    ↓
Raw Tweet
    ↓
AI Analysis V1
    ↓
AI Analysis V2

Historical analysis should be reproducible or replaceable whenever practical.

---

## 16. Timezone

Database timestamps should use timestamptz.

The system must not hard-code UTC+8 into database logic.

User timezone should be stored as an IANA timezone identifier,
for example:

Asia/Shanghai

The initial default timezone is Asia/Shanghai.

---

## 17. Database Version Control

Database schema changes must be stored as migrations in:

supabase/migrations/

Database changes should not exist only as undocumented manual changes in the
Supabase dashboard.

GitHub should remain the source of truth for database schema versions.

---

## 18. Development Rules

Before implementing a major feature, check:

1. Logic
2. Database structure
3. RLS / security
4. Cost
5. Replaceability
6. Failure handling
7. Future APP / Mini Program compatibility
8. Code simplicity
9. Dependency count
10. Browser-based testing

Do not implement a feature until its architecture has been checked.

---

## 19. Development Strategy

Build the smallest working version first.

Recommended order:

Phase 1:
Architecture + database + authentication + permissions

Phase 2:
Independent X data collector

Phase 3:
Data storage and normalization

Phase 4:
Keyword filtering

Phase 5:
AI analysis

Phase 6:
Investment intelligence frontend

Phase 7:
Personalized investment radar

Phase 8:
Future APP / WeChat Mini Program

Each phase must be tested before moving to the next phase.

---

## 20. Engineering Principle

Do not over-engineer the system.

Prefer:

- Simple
- Standard
- Replaceable
- Testable
- Secure
- Maintainable

Avoid unnecessary abstraction and unnecessary dependencies.

The system should remain understandable to a beginner maintaining it through
GitHub, Supabase, and Lovable.
