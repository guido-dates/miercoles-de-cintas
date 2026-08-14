# Miércoles de Cintas 🎬

Hub del cine club: funciones vistas, recomendaciones con votación (+1 / −1 / 👁 Ya la vi),
búsqueda de películas (títulos en español y por director) y countdown a la próxima función.
Un solo `index.html`, sin build, sin framework. Backend: Supabase.

## Poner el logo

Guardá la imagen del papa como `logo.png` en esta carpeta. Si no está, muestra un fallback y no rompe nada.

**URL en vivo:** https://guido-dates.github.io/miercoles-de-cintas/

## Los 3 modos de datos

1. **Sin configurar nada** → funciona, pero cada navegador ve solo sus datos (localStorage). Sirve para probar.
2. **Con Supabase** → datos compartidos entre los 4. **Ya configurado** (proyecto `miercoles-de-cintas`, región `sa-east-1`).
3. **Con OMDb** → ratings IMDb + Rotten Tomatoes y pósters. **Ya configurado.**

### Supabase — ya hecho

Proyecto: `sdnhxripjpjaevafiguk` · Dashboard: https://supabase.com/dashboard/project/sdnhxripjpjaevafiguk
El schema aplicado está en `schema.sql`. Las credenciales (URL + anon key) ya están en el bloque `CONFIG` de `index.html`.

> **Ojo:** el repo es público, así que la anon key + URL del proyecto son buscables (no solo "quien tenga el link").
> La key anon es pública por diseño en cualquier sitio estático; el riesgo real es que alguien escriba en la DB.
> Mitigado con constraints (solo los 4 nombres como autor/votante, largos limitados) y **backup diario**:
> un GitHub Action ([.github/workflows/backup.yml](.github/workflows/backup.yml)) vuelca las 4 tablas a la rama
> [`backups`](https://github.com/guido-dates/miercoles-de-cintas/tree/backups) (06:00 AR, solo commitea si cambió;
> el historial de git guarda todas las versiones). Restaurar = insertar esos JSON vía REST con la misma key.

### OMDb — ratings IMDb / Rotten Tomatoes — ya hecho

Key en `CONFIG.OMDB_API_KEY` (gratis, 1000 req/día en [omdbapi.com/apikey.aspx](https://www.omdbapi.com/apikey.aspx)).
Resultados cacheados en localStorage; el límite diario no es problema.

### Búsqueda de películas

Tres fuentes encadenadas, sin keys nuevas:

1. **Autocomplete de IMDb** vía Edge Function propia (`supabase/functions/imdb-suggest`) que le agrega CORS.
   Matchea títulos en español ("el padrino" → The Godfather) porque usa el índice de AKAs de IMDb.
   *Endpoint no documentado*: si algún día muere, la búsqueda degrada sola a OMDb (títulos en inglés).
   Plan B documentado: migrar a [TMDB](https://developer.themoviedb.org) (key gratis, búsqueda multiidioma + personas).
2. **Wikidata SPARQL** para filmografías de directores (click en el chip 🎬 de una persona).
3. **OMDb** para la ficha (ratings, director, póster) de cada resultado elegido.

Redeploy de la función: `SUPABASE_ACCESS_TOKEN=... npx supabase functions deploy imdb-suggest --project-ref sdnhxripjpjaevafiguk --no-verify-jwt --use-api`

## Deploy — GitHub Pages

Repo: https://github.com/guido-dates/miercoles-de-cintas — Pages sirve `main` desde la raíz.

Para publicar cambios:
```bash
cd ~/projects/miercoles-de-cintas
git add -A && git commit -m "cambios" && git push
```
Pages rebuildea solo (1-2 min; el CDN cachea hasta 10 min).

## Vistas y recomendaciones

Todo se administra desde la UI: buscás una película y elegís **Proponer** (va a recomendaciones,
se vota) o **✔ La vimos** (va a vistas con el Nº siguiente; si estaba propuesta, sale sola de recs).
Cada uno borra solo lo que agregó. Las 4 funciones históricas (`added_by` null) se tocan solo por SQL.

El countdown de la próxima función se configura en `CONFIG`: `ANCHOR_DATE` (una función pasada) y `PERIOD_DAYS` (14).

## Futuro (cuando pinte)

- **Puntajes/reviews propios**: la tabla `votes` ya tiene la estructura para crecer — agregar columnas `rating smallint` y `review text` y los botones en la UI. Nada del esquema actual lo bloquea.
