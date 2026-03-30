# Author: Bhavin Pathak
# Description: Modern & Classic Web Browsers Installer (Windows)

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
    if (Ask-Install $name) {
        Write-Msg "Installing $name"
        winget install -e --id $id --accept-source-agreements --accept-package-agreements
        Write-Success "$name Installed."
    }
}

Clear-Host
Write-Host "Web Browser Setup (Windows)" -ForegroundColor Cyan
Write-Host "------------------------"

Install-WingetApp "Google.Chrome" "Google Chrome"
Install-WingetApp "Microsoft.Edge" "Microsoft Edge"
Install-WingetApp "Brave.Brave" "Brave Browser"
Install-WingetApp "Mozilla.Firefox" "Firefox"
Install-WingetApp "Hibbiki.Chromium" "Chromium"
Install-WingetApp "VivaldiTechnologies.Vivaldi" "Vivaldi"
Install-WingetApp "Opera.Opera" "Opera"
Install-WingetApp "LibreWolf.LibreWolf" "Librewolf"
Install-WingetApp "TorProject.TorBrowser" "Tor Browser"

Write-Host "`nBrowser Setup Complete! 🌐`n" -ForegroundColor Green
