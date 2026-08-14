// Proxy CORS para el autocomplete de IMDb (v2.sg.media-imdb.com).
// IMDb no manda Access-Control-Allow-Origin, así que el browser no puede
// llamarlo directo; esta función lo repite con CORS abierto.
// Nota: endpoint no documentado (es el que usa la barra de imdb.com).
// Si algún día muere, el front degrada solo a la búsqueda OMDb.
// Alternativa documentada: TMDB (ver README).

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  const q = (new URL(req.url).searchParams.get("q") ?? "").trim().toLowerCase();
  if (q.length < 2) {
    return new Response('{"d":[]}', { headers: { ...CORS, "Content-Type": "application/json" } });
  }

  const first = /[a-z0-9]/.test(q[0]) ? q[0] : "x";
  const url = `https://v2.sg.media-imdb.com/suggestion/${first}/${encodeURIComponent(q)}.json`;

  try {
    const r = await fetch(url, { headers: { "User-Agent": "Mozilla/5.0" } });
    const body = await r.text();
    return new Response(body, {
      status: r.status,
      headers: { ...CORS, "Content-Type": "application/json", "Cache-Control": "public, max-age=86400" },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 502,
      headers: { ...CORS, "Content-Type": "application/json" },
    });
  }
});
