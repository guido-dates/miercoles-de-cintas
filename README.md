# Miércoles de Cintas 🎬

Hub del cine club: películas vistas, recomendaciones y votación (+1 / −1 / 👁 Ya la vi).
Un solo archivo (`index.html`), sin build, sin framework.

## Poner el logo

Guardá la imagen del papa como `logo.png` en esta carpeta. Si no está, muestra un fallback y no rompe nada.

**URL en vivo:** https://guido-dates.github.io/miercoles-de-cintas/

## Los 3 modos de datos

1. **Sin configurar nada** → funciona, pero cada navegador ve solo sus datos (localStorage). Sirve para probar.
2. **Con Supabase** → datos compartidos entre los 4. **Ya configurado** (proyecto `miercoles-de-cintas`, región `sa-east-1`).
3. **Con OMDb** → ratings IMDb + Rotten Tomatoes automáticos (pendiente: falta la key).

### Supabase — ya hecho

Proyecto: `sdnhxripjpjaevafiguk` · Dashboard: https://supabase.com/dashboard/project/sdnhxripjpjaevafiguk
El schema aplicado está en `schema.sql`. Las credenciales (URL + anon key) ya están en el bloque `CONFIG` de `index.html`.

> **Ojo:** el repo es público, así que la anon key + URL del proyecto son buscables (no solo "quien tenga el link").
> La key anon es pública por diseño en cualquier sitio estático; el riesgo real es que alguien escriba en la DB.
> Mitigado con constraints (solo los 4 nombres como autor/votante, largos limitados). Peor caso: borran la lista — no hay data sensible.

### OMDb — ratings IMDb / Rotten Tomatoes (2 minutos, gratis)

1. Key gratis (1000 requests/día) en [omdbapi.com/apikey.aspx](https://www.omdbapi.com/apikey.aspx) — llega por mail, hay que clickear el link de activación.
2. En `CONFIG`: `OMDB_API_KEY: "abc123"`.

Los resultados se cachean en localStorage, así que el límite diario no es problema.
Si una película matchea mal (títulos ambiguos tipo "Obsession"), en `CONFIG.WATCHED` podés fijar `search` (título en inglés) y `y` (año).

## Deploy — GitHub Pages

Repo: https://github.com/guido-dates/miercoles-de-cintas — Pages sirve `main` desde la raíz.

Para publicar cambios:
```bash
cd ~/projects/miercoles-de-cintas
git add -A && git commit -m "cambios" && git push
```
Pages rebuildea solo (1-2 min; el CDN cachea hasta 10 min).

## Editar la lista de vistas

En `CONFIG.WATCHED` de `index.html`:
```js
{ title: "El Padrino", search: "The Godfather", y: 1972 },
```
Agregar línea, guardar, `git push`.

## Futuro (cuando pinte)

- **Puntajes/reviews propios**: la tabla `votes` ya tiene la estructura para crecer — agregar columnas `rating smallint` y `review text` y los botones en la UI. Nada del esquema actual lo bloquea.
- Mover una rec ganadora a "vistas" automáticamente.
