# Supabase Migration Strategy & Workflow

This document outlines the strategy for managing database schema changes using Supabase CLI.

## Prerequisities
- Docker (must be running)
- Node.js (for `npx`)

## Local Development Workflow

### 1. Start Local Supabase
To start the local Supabase instance (database, auth, storage, etc.):

```bash
npx supabase start
```
This will output your local API URL, Anon Key, and Studio URL (dashboard).

### 2. Status
To check the status of your local instance:
```bash
npx supabase status
```

### 3. Stop Local Supabase
```bash
npx supabase stop
```

## Migration Workflow

### 1. Create a New Migration
When you need to change the schema (e.g., add a table), create a new migration file:

```bash
npx supabase migration new <name_of_change>
```
Example: `npx supabase migration new create_profiles_table`

This creates a SQL file in `supabase/migrations/`. Edit this file with your SQL statements.

### 2. Apply Migrations Locally
To apply all pending migrations to your local database:

```bash
npx supabase db reset
```
*Note: `db reset` recreates the database from scratch (applying all migrations). Use `db up` if you want to apply only new migrations without resetting data (though reset is often cleaner for dev).*

### 3. Seed Data (Optional)
You can add seed data in `supabase/seed.sql`. This data is automatically loaded when you run `db reset`.

## Deployment (Production)

To deploy your migrations to the remote Supabase project:

1. Link your project (do this once):
   ```bash
   npx supabase link --project-ref <your-project-id>
   ```
   You will need your database password.

2. Push migrations:
   ```bash
   npx supabase db push
   ```

## Schema Management Strategy
- **Always** make schema changes via migration files.
- **Never** modify the production database schema directly via the Supabase Dashboard if you can avoid it, as it breaks the version control source of truth.
- Commit all migration files to Git.
