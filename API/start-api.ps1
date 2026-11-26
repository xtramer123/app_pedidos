$wd = 'C:\Users\IsaacPC\Documents\APPpedidos-PC\app_pedidos\API'
$py = Join-Path $wd '.venv\Scripts\python.exe'
$out = Join-Path $wd 'uvicorn.out.log'
$err = Join-Path $wd 'uvicorn.err.log'
$listen = Get-NetTCPConnection -LocalPort 8000 -State Listen -ErrorAction SilentlyContinue
if (-not $listen) {
  Start-Process -FilePath $py -ArgumentList '-m','uvicorn','app.main:app','--host','0.0.0.0','--port','8000' -WorkingDirectory $wd -WindowStyle Hidden -RedirectStandardOutput $out -RedirectStandardError $err
  Start-Sleep -Seconds 3
}
$status = try { (Invoke-RestMethod -Uri http://127.0.0.1:8000/ -TimeoutSec 5).status } catch { 'down' }
Write-Output "api:$status"
