# Author: Bhavin Pathak
# Description: Database Stack (Servers + GUIs) (Windows)

$ErrorActionPreference = "Continue"

function Write-Msg ($text) { Write-Host "`n>>> $text..." -ForegroundColor Cyan }
function Write-Skip ($text) { Write-Host "Skipped $text." -ForegroundColor Red }

function Ask-Install ($name) {
    Write-Host "Install $name? [y/n]" -ForegroundColor Yellow -NoNewline
    $choice = Read-Host " >"
    if ($choice -match "^[yY]") { return $true }
    Write-Skip $name
    return $false
}

function Install-WingetApp {
    param($id, $name, $cmd)
    if ($cmd -and (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Host "✔ $name is already installed." -ForegroundColor Green
        return
    }
    $installed = winget list --id $id -e | Out-String
    if ($installed -match $id) {
        Write-Host "✔ $name is already installed." -ForegroundColor Green
        return
    }
    if (Ask-Install $name) {
        Write-Msg "Installing $name"
        winget install -e --id $id --accept-source-agreements --accept-package-agreements
        Write-Host "✔ $name Installed." -ForegroundColor Green
    }
}

Clear-Host
Write-Host "Database Tools & Servers (Windows)" -ForegroundColor Cyan
Write-Host "------------------------"

Write-Host "`n--- PostgreSQL Stack ---" -ForegroundColor Yellow
Install-WingetApp "PostgreSQL.PostgreSQL" "PostgreSQL Server" "psql"
Install-WingetApp "pgAdmin.pgAdmin" "pgAdmin4 (GUI)" ""

Write-Host "`n--- MongoDB Stack ---" -ForegroundColor Yellow
Install-WingetApp "MongoDB.Server" "MongoDB Server" "mongod"
Install-WingetApp "MongoDB.Compass.Full" "MongoDB Compass (GUI)" ""

Write-Host "`n--- Redis Stack ---" -ForegroundColor Yellow
Write-Host "⚠️ Official Redis Server is not natively supported on Windows. Use Docker/WSL or Memurai." -ForegroundColor Yellow
Install-WingetApp "Redis.RedisInsight" "RedisInsight (GUI)" ""

Write-Host "`n--- Milvus Stack ---" -ForegroundColor Yellow
Write-Host "⚠️ Milvus Server is officially supported via Docker on Windows. Winget package unavailable." -ForegroundColor Yellow
Install-WingetApp "Zilliz.Attu" "Attu (GUI)" ""

Write-Host "`n--- Universal Tools ---" -ForegroundColor Yellow
Install-WingetApp "dbeaver.dbeaver" "DBeaver" ""
Install-WingetApp "BeekeeperStudio.BeekeeperStudio" "Beekeeper Studio" ""

Write-Host "`nDB Tools Setup Complete! 🗄️`n" -ForegroundColor Green
