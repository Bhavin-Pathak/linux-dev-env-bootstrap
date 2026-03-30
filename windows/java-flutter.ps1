# Author: Bhavin Pathak
# Description: Flutter, Dart, & Android Studio Setup (Windows)

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
Write-Host "Flutter & Mobile Dev Setup (Windows)" -ForegroundColor Cyan
Write-Host "---------------------------"

Install-WingetApp "Microsoft.OpenJDK.17" "Java (OpenJDK 17)" "java"

if (Get-Command fvm -ErrorAction SilentlyContinue) {
    Write-Host "✔ FVM (Flutter) is already installed." -ForegroundColor Green
} else {
    if (Ask-Install "Flutter (via FVM)") {
        Write-Msg "Installing FVM"
        Invoke-WebRequest -Uri "https://fvm.app/install.ps1" -UseBasicParsing | Invoke-Expression
        if (Get-Command fvm -ErrorAction SilentlyContinue) {
            fvm install stable
            fvm global stable
            Write-Host "FVM Installed. Please restart your terminal so you can use 'flutter' & 'dart'." -ForegroundColor Green
        } else {
            Write-Host "FVM Installed but requires a terminal restart to be available in PATH." -ForegroundColor Yellow
        }
    }
}

Install-WingetApp "Google.AndroidStudio" "Android Studio"

Write-Host "`nSetup Complete! 📱" -ForegroundColor Green
Write-Host "Don't forget to run 'flutter doctor' after restarting your terminal.`n" -ForegroundColor Yellow
