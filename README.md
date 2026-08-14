# Miércoles de Cintas 🎬

Hub del cine club: películas vistas, recomendaciones y votación (+1 / −1 / 👁 Ya la vi).
Un solo archivo (`index.html`), sin build, sin framework.

## Poner el logo

Guardá la imagen del papa como `logo.png` en esta carpeta. Si no está, muestra un fallback y no rompe nada.

## Los 3 modos de datos

1. **Sin configurar nada** → funciona ya, pero cada navegador ve solo sus datos (localStorage). Sirve para probar.
2. **Con Supabase** → datos compartidos entre los 4. Es lo que quieren.
3. **Con OMDb** → ratings IMDb + Rotten Tomatoes automáticos (opcional, se combina con lo anterior).

### Supabase (5 minutos, gratis)

1. Cuenta en [supabase.com](https://supabase.com) → New project (plan free).
2. Dashboard → **SQL Editor** → pegar el contenido de `schema.sql` → Run.
3. Dashboard → **Settings → API** → copiar `Project URL` y `anon public key`.
4. En `index.html`, bloque `CONFIG` (arriba del script):
   ```js
   SUPABASE_URL: "https://TUPROYECTO.supabase.co",
   SUPABASE_ANON_KEY: "eyJ...",
   ```

> El anon key va en el HTML y es visible: cualquiera con el link puede votar.
> Para un grupo de 4 amigos está bien; no compartan la URL fuera del grupo.

### OMDb — ratings IMDb / Rotten Tomatoes (2 minutos, gratis)

1. Key gratis (1000 requests/día) en [omdbapi.com/apikey.aspx](https://www.omdbapi.com/apikey.aspx) — llega por mail, hay que clickear el link de activación.
2. En `CONFIG`: `OMDB_API_KEY: "abc123"`.

Los resultados se cachean en localStorage, así que el límite diario no es problema.
Si una película matchea mal (títulos ambiguos tipo "Obsession"), en `CONFIG.WATCHED` podés fijar `search` (título en inglés) y `y` (año).

## Deploy

**Vercel** (recomendado):
```bash
cd miercoles-de-cintas
npx vercel --prod
```
Login con GitHub/mail la primera vez, enter a todo, te da la URL. Fin.

**Alternativa sin terminal:** [Netlify Drop](https://app.netlify.com/drop) — arrastrás la carpeta al navegador.

## Editar la lista de vistas

En `CONFIG.WATCHED` de `index.html`:
```js
{ title: "El Padrino", search: "The Godfather", y: 1972 },
```
Agregar línea, guardar, redeploy (`npx vercel --prod`).

## Futuro (cuando pinte)

- **Puntajes/reviews propios**: la tabla `votes` ya tiene la estructura para crecer — agregar columnas `rating smallint` y `review text` y los botones en la UI. Nada del esquema actual lo bloquea.
- Mover una rec ganadora a "vistas" automáticamente.
