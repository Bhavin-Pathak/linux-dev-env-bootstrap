# Author: Bhavin Pathak
# Description: Modern IDEs & Editors Installer (Windows)

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
    param($id, $name)
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
Write-Host "IDE & Editor Setup (Windows)" -ForegroundColor Cyan
Write-Host "------------------------"

Install-WingetApp "Microsoft.VisualStudioCode" "VS Code"
Install-WingetApp "Anysphere.Cursor" "Cursor IDE"
Install-WingetApp "Codeium.Windsurf" "Windsurf IDE"
Install-WingetApp "SublimeHQ.SublimeText.4" "Sublime Text"
Install-WingetApp "Notepad++.Notepad++" "Notepad++"

Write-Host "`nIDE Setup Complete! 💻`n" -ForegroundColor Green
