-- Miércoles de Cintas — schema para Supabase
-- Pegar en: Supabase Dashboard → SQL Editor → Run

create table if not exists recs (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  author text not null,
  comment text,
  imdb_id text,   -- del autocomplete OMDb; permite lookup exacto de ratings
  year text,
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
-- El anon key es público (está en el HTML y en este repo), así que el daño
-- posible se acota con constraints: solo los 4 nombres, largos limitados.
alter table recs enable row level security;
alter table votes enable row level security;

create policy "anon_all_recs"  on recs  for all using (true) with check (true);
create policy "anon_all_votes" on votes for all using (true) with check (true);

alter table recs  add constraint recs_author_valid check (author in ('Marcos','Tomi','Juan','Guido'));
alter table recs  add constraint recs_title_len    check (char_length(title) between 1 and 120);
alter table recs  add constraint recs_comment_len  check (comment is null or char_length(comment) <= 200);
alter table votes add constraint votes_voter_valid check (voter in ('Marcos','Tomi','Juan','Guido'));

-- Funciones ya vistas (orden = position; las de la era pre-app tienen added_by null)
create table if not exists watched (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  imdb_id text,
  year text,
  position int not null,
  added_by text,
  created_at timestamptz not null default now()
);
alter table watched enable row level security;
create policy "anon_all_watched" on watched for all using (true) with check (true);
alter table watched add constraint watched_title_len    check (char_length(title) between 1 and 120);
alter table watched add constraint watched_added_by_valid check (added_by is null or added_by in ('Marcos','Tomi','Juan','Guido'));

-- Hilos de comentarios en recomendaciones
create table if not exists rec_comments (
  id uuid primary key default gen_random_uuid(),
  rec_id uuid not null references recs(id) on delete cascade,
  author text not null,
  body text not null,
  created_at timestamptz not null default now()
);
alter table rec_comments enable row level security;
create policy "anon_all_rec_comments" on rec_comments for all using (true) with check (true);
alter table rec_comments add constraint rec_comments_author_valid check (author in ('Marcos','Tomi','Juan','Guido'));
alter table rec_comments add constraint rec_comments_body_len check (char_length(body) between 1 and 300);
