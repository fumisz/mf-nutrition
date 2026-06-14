/* MF Nutrition — service worker (shell offline) */
const CACHE = 'mfn-v3';
const SHELL = [
  './index.html',
  './manifest.json',
  './config.js',
  './lib/react.js',
  './lib/react-dom.js',
  './lib/babel.js',
  './icons/icon-192.png',
  './icons/icon-512.png'
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);
  // Nunca cachear chamadas ao Supabase / CDNs dinâmicos — sempre rede.
  if (url.hostname.includes('supabase') || url.hostname.includes('jsdelivr') || url.hostname.includes('unpkg')) {
    return; // deixa o navegador lidar (rede)
  }
  // Shell: cache-first
  e.respondWith(
    caches.match(e.request).then(r => r || fetch(e.request).then(resp => {
      if (e.request.method === 'GET' && resp.ok && url.origin === location.origin) {
        const copy = resp.clone();
        caches.open(CACHE).then(c => c.put(e.request, copy));
      }
      return resp;
    }).catch(() => caches.match('./index.html')))
  );
});
