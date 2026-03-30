# Author: Bhavin Pathak
# Description: Safe System Cleanup & Maintenance Tool (Windows)

$ErrorActionPreference = "Continue"

function Write-Msg ($text) {
    Write-Host "`n>>> $text..." -ForegroundColor Cyan
}

Clear-Host
Write-Host "System Cleanup Tool (Windows)" -ForegroundColor Cyan
Write-Host "-------------------"
Write-Host "⚠️  This will remove unused caches, temp files, and Docker items." -ForegroundColor Yellow
Write-Host "⚠️  Your projects and personal data are SAFE.`n" -ForegroundColor Yellow

$choice = Read-Host "Start cleanup? (y/N)"
if ($choice -notmatch "^[yY]") {
    Write-Host "Aborted." -ForegroundColor Red
    exit
}

Write-Msg "Cleaning Windows Temp Files"
Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Msg "Cleaning Development Caches"
# Pip
if (Test-Path "$env:LOCALAPPDATA\pip\cache") { Remove-Item -Path "$env:LOCALAPPDATA\pip\cache\*" -Recurse -Force -ErrorAction SilentlyContinue }
# Npm
if (Test-Path "$env:LOCALAPPDATA\npm-cache") { Remove-Item -Path "$env:LOCALAPPDATA\npm-cache\*" -Recurse -Force -ErrorAction SilentlyContinue }
# Yarn
if (Test-Path "$env:LOCALAPPDATA\Yarn\Cache") { Remove-Item -Path "$env:LOCALAPPDATA\Yarn\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue }

Write-Msg "Emptying Recycle Bin"
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Write-Msg "Checking Docker Environment"
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $dockerInfo = docker info 2>&1
    if ($dockerInfo -match "Server Version") {
        Write-Host "Pruning Docker (unused images, networks)..." -ForegroundColor Yellow
        docker system prune -f
        Write-Host "✔ Docker cleanup completed" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Docker daemon is not running. Skipped Docker cleanup." -ForegroundColor Yellow
    }
}

Write-Host "`n✨ System Cleaned Successfully! ✨`n" -ForegroundColor Green
