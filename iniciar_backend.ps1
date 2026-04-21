# ============================================================
#  Script de inicio del backend Pandora (Desarrollo)
#  Ejecutar desde PowerShell: .\iniciar_backend.ps1
# ============================================================

Write-Host "Iniciando Pandora Backend..." -ForegroundColor Cyan

# 1. Asegurar que LocalDB esta corriendo
$info = SqlLocalDB info MSSQLLocalDB 2>&1 | Out-String
if ($info -match "Detenido|Stopped") {
    Write-Host "Iniciando LocalDB MSSQLLocalDB..." -ForegroundColor Yellow
    SqlLocalDB start MSSQLLocalDB | Out-Null
    Start-Sleep -Seconds 2
}
Write-Host "LocalDB: OK" -ForegroundColor Green

# 2. Entorno de desarrollo
$env:ASPNETCORE_ENVIRONMENT = "Development"

# 3. Arrancar el backend
$backendPath = Join-Path $PSScriptRoot "Pandora\backend\Pandora.API"
Write-Host "Directorio: $backendPath" -ForegroundColor Gray
Set-Location $backendPath
dotnet run
