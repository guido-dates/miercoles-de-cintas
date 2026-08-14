-- Miércoles de Cintas — schema para Supabase
-- Pegar en: Supabase Dashboard → SQL Editor → Run

create table if not exists recs (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  author text not null,
  comment text,
  created_at timestamptz not null default now()
);

create table if not exists votes (
  rec_id uuid not null references recs(id) on delete cascade,
  voter text not null,
  vote smallint check (vote in (1, -1) or vote is null),
  seen boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (rec_id, voter)
);

-- RLS abierto al anon key: es un hub entre amigos, no un banco.
-- Cualquiera con la URL + anon key puede escribir; no publiques el link fuera del grupo.
alter table recs enable row level security;
alter table votes enable row level security;

create policy "anon_all_recs"  on recs  for all using (true) with check (true);
create policy "anon_all_votes" on votes for all using (true) with check (true);
