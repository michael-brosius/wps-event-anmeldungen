-- WPS Event-Anmeldungen v3.0
create table if not exists public.event_registrations (
  identity_key text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  updated_by uuid default auth.uid()
);

alter table public.event_registrations enable row level security;

revoke all on table public.event_registrations from anon;
grant select, insert, update, delete on table public.event_registrations to authenticated;

drop policy if exists "wps_read" on public.event_registrations;
create policy "wps_read" on public.event_registrations for select to authenticated
using ((auth.jwt() ->> 'email') like '%@wps.de');

drop policy if exists "wps_insert" on public.event_registrations;
create policy "wps_insert" on public.event_registrations for insert to authenticated
with check ((auth.jwt() ->> 'email') like '%@wps.de');

drop policy if exists "wps_update" on public.event_registrations;
create policy "wps_update" on public.event_registrations for update to authenticated
using ((auth.jwt() ->> 'email') like '%@wps.de')
with check ((auth.jwt() ->> 'email') like '%@wps.de');

drop policy if exists "wps_delete" on public.event_registrations;
create policy "wps_delete" on public.event_registrations for delete to authenticated
using ((auth.jwt() ->> 'email') like '%@wps.de');
