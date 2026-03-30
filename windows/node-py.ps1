# Author: Bhavin Pathak
# Description: Unified Node.js & Python Stack Setup (Windows)

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

Clear-Host
Write-Host "Node.js & Python Stack Setup (Windows)" -ForegroundColor Cyan
Write-Host "---------------------------------"

Write-Host "`n--- Node.js Stack ---" -ForegroundColor Yellow

# NVM & Node
$nvmInstalled = Get-Command nvm -ErrorAction SilentlyContinue
if ($nvmInstalled) {
    Write-Host "✔ NVM-Windows is already installed." -ForegroundColor Green
} else {
    if (Ask-Install "NVM-Windows & Node.js (LTS)") {
        Write-Msg "Installing NVM for Windows"
        winget install -e --id CoreyButler.NVMforWindows --accept-source-agreements
        Write-Host "Please restart terminal later to use nvm commands." -ForegroundColor Yellow
    }
}

# Corepack / Yarn / PNPM
if (Get-Command corepack -ErrorAction SilentlyContinue) {
    if (Ask-Install "Yarn (via Corepack)") { corepack enable; corepack prepare yarn@stable --activate }
    if (Ask-Install "PNPM (via Corepack)") { corepack enable; corepack prepare pnpm@latest --activate }
} else {
    Write-Host "⚠️ Node/Corepack not found yet. Install Node.js first." -ForegroundColor Red
}

# Bun
if (Get-Command bun -ErrorAction SilentlyContinue) {
    Write-Host "✔ Bun is already installed." -ForegroundColor Green
} else {
    if (Ask-Install "Bun") {
        Write-Msg "Installing Bun"
        Invoke-WebRequest -Uri "https://bun.sh/install.ps1" -UseBasicParsing | Invoke-Expression
    }
}

# Nodemon
if (Get-Command npm -ErrorAction SilentlyContinue) {
    if (Ask-Install "Nodemon") { npm install -g nodemon }
}

Write-Host "`n--- Python Stack ---" -ForegroundColor Yellow

if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "✔ Python is already installed." -ForegroundColor Green
} else {
    if (Ask-Install "Python 3") {
        Write-Msg "Installing Python 3.12"
        winget install -e --id Python.Python.3.12 --accept-source-agreements
    }
}

Write-Host "`nStack Setup Complete! 🚀`n" -ForegroundColor Green
