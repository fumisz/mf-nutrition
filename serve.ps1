# Servidor estático simples para testar o MF Nutrition localmente.
# Uso:  powershell -ExecutionPolicy Bypass -File serve.ps1
$port = 5510
$root = $PSScriptRoot
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "MF Nutrition em  http://localhost:$port/  (Ctrl+C para parar)"
$mimes = @{ '.html'='text/html; charset=utf-8';'.js'='application/javascript; charset=utf-8';
  '.json'='application/json; charset=utf-8';'.png'='image/png';'.svg'='image/svg+xml';
  '.css'='text/css; charset=utf-8';'.ico'='image/x-icon';'.md'='text/plain; charset=utf-8' }
try {
  while ($listener.IsListening) {
    $ctx = $null
    try {
      $ctx = $listener.GetContext()
      $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
      if ([string]::IsNullOrEmpty($rel)) { $rel = 'index.html' }
      $path = Join-Path $root $rel
      $ctx.Response.KeepAlive = $false
      if (Test-Path $path -PathType Leaf) {
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $ext = [System.IO.Path]::GetExtension($path).ToLower()
        if ($mimes.ContainsKey($ext)) { $ctx.Response.ContentType = $mimes[$ext] }
        $ctx.Response.SendChunked = $false
        $ctx.Response.ContentLength64 = $bytes.Length
        if ($ctx.Request.HttpMethod -ne 'HEAD') {
          $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        }
      } else {
        $ctx.Response.StatusCode = 404
        $ctx.Response.ContentLength64 = 0
      }
    } catch {
      Write-Host "req erro: $($_.Exception.Message)"
    } finally {
      if ($ctx) { try { $ctx.Response.Close() } catch {} }
    }
  }
} finally { $listener.Stop() }
