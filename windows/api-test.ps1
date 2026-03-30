# Author: Bhavin Pathak
# Description: Essential API Testing Tools Setup (Windows)

$ErrorActionPreference = "Stop"

# Styling Functions
function Write-Msg ($text) {
    Write-Host "`n>>> $text..." -ForegroundColor Cyan
}
function Write-Success ($text) {
    Write-Host "✔ $text" -ForegroundColor Green
}
function Write-Skip ($text) {
    Write-Host "Skipped $text." -ForegroundColor Red
}

function Ask-Install ($name) {
    Write-Host "Install $name? [y/n]" -ForegroundColor Yellow -NoNewline
    $choice = Read-Host " >"
    if ($choice -match "^[yY]") { return $true }
    Write-Skip $name
    return $false
}

function Install-WingetApp {
    param($id, $name)
    $installed = winget list --id $id -e | Out-String
    if ($installed -match $id) {
        Write-Success "$name is already installed."
        return
    }
    Write-Msg "Installing $name"
    winget install -e --id $id --accept-source-agreements --accept-package-agreements
    Write-Success "$name Installed."
}

Clear-Host
Write-Host "API Testing Tools Setup (Windows)" -ForegroundColor Cyan
Write-Host "----------------------"

if (Ask-Install "Postman") { Install-WingetApp "Postman.Postman" "Postman" }
if (Ask-Install "Insomnia") { Install-WingetApp "Insomnia.Insomnia" "Insomnia" }

Write-Host "`nAPI Tools Ready! 🚀`n" -ForegroundColor Green
