-- Project Hub · Supabase schema
-- Ejecutar una vez en Supabase > SQL Editor.
-- Requiere Supabase Auth. Las políticas RLS aíslan los datos por usuario.

create extension if not exists pgcrypto;

create table if not exists public.project_hub_projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  source text not null check (source in ('github', 'manual')),
  source_key text not null,
  github_id bigint,
  github_owner text,
  github_name text,
  github_full_name text,
  github_visibility text,
  github_language text,
  github_default_branch text,
  github_archived boolean not null default false,
  github_fork boolean not null default false,
  github_stars integer not null default 0,
  github_open_issues integer not null default 0,
  github_topics text[] not null default '{}',
  github_pushed_at timestamptz,
  github_synced_at timestamptz,
  name text not null,
  description text not null default '',
  status text not null default 'active' check (status in ('active', 'paused', 'idea', 'complete')),
  priority text not null default 'medium' check (priority in ('high', 'medium', 'low')),
  version text not null default '',
  category text not null default '',
  tech text[] not null default '{}',
  live_url text not null default '',
  repo_url text not null default '',
  notes text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, source, source_key)
);

create table if not exists public.project_hub_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  project_id uuid not null references public.project_hub_projects(id) on delete cascade,
  title text not null,
  priority text not null default 'medium' check (priority in ('high', 'medium', 'low')),
  due_date date,
  done boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.project_hub_set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists project_hub_projects_updated_at on public.project_hub_projects;
create trigger project_hub_projects_updated_at
before update on public.project_hub_projects
for each row execute function public.project_hub_set_updated_at();

drop trigger if exists project_hub_tasks_updated_at on public.project_hub_tasks;
create trigger project_hub_tasks_updated_at
before update on public.project_hub_tasks
for each row execute function public.project_hub_set_updated_at();

alter table public.project_hub_projects enable row level security;
alter table public.project_hub_tasks enable row level security;

drop policy if exists "Project Hub users read own projects" on public.project_hub_projects;
create policy "Project Hub users read own projects" on public.project_hub_projects for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "Project Hub users insert own projects" on public.project_hub_projects;
create policy "Project Hub users insert own projects" on public.project_hub_projects for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "Project Hub users update own projects" on public.project_hub_projects;
create policy "Project Hub users update own projects" on public.project_hub_projects for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Project Hub users delete own projects" on public.project_hub_projects;
create policy "Project Hub users delete own projects" on public.project_hub_projects for delete to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "Project Hub users read own tasks" on public.project_hub_tasks;
create policy "Project Hub users read own tasks" on public.project_hub_tasks for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "Project Hub users insert own tasks" on public.project_hub_tasks;
create policy "Project Hub users insert own tasks" on public.project_hub_tasks for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "Project Hub users update own tasks" on public.project_hub_tasks;
create policy "Project Hub users update own tasks" on public.project_hub_tasks for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Project Hub users delete own tasks" on public.project_hub_tasks;
create policy "Project Hub users delete own tasks" on public.project_hub_tasks for delete to authenticated using ((select auth.uid()) = user_id);

create index if not exists project_hub_projects_user_updated_idx on public.project_hub_projects (user_id, updated_at desc);
create index if not exists project_hub_projects_user_source_idx on public.project_hub_projects (user_id, source);
create index if not exists project_hub_tasks_user_done_idx on public.project_hub_tasks (user_id, done, created_at desc);
