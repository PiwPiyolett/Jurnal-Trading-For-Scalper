-- =====================================================================
--  Jurnal Scalper — Skema Database Supabase
--  Cara pakai: Buka Supabase → menu "SQL Editor" → "New query" →
--  tempel SELURUH isi file ini → klik "Run".
--  Aman dijalankan berkali-kali (idempoten).
-- =====================================================================

-- Tabel penyimpanan jurnal: satu baris per user, seluruh data disimpan
-- sebagai JSON pada kolom "data".
create table if not exists public.journals (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Aktifkan Row Level Security: tanpa ini, data bisa diakses siapa saja.
alter table public.journals enable row level security;

-- KEBIJAKAN: setiap user HANYA boleh mengakses barisnya sendiri.
drop policy if exists "journals_select_own" on public.journals;
create policy "journals_select_own" on public.journals
  for select using (auth.uid() = user_id);

drop policy if exists "journals_insert_own" on public.journals;
create policy "journals_insert_own" on public.journals
  for insert with check (auth.uid() = user_id);

drop policy if exists "journals_update_own" on public.journals;
create policy "journals_update_own" on public.journals
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "journals_delete_own" on public.journals;
create policy "journals_delete_own" on public.journals
  for delete using (auth.uid() = user_id);

-- Selesai. Setiap orang yang mendaftar akan otomatis mendapat
-- jurnal pribadi yang terisolasi dari user lain.
