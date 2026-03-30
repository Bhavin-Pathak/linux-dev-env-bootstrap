# Author: Bhavin Pathak
# Description: Essential Desktop Apps (Windows)

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
Write-Host "Essential Apps & Tools (Windows)" -ForegroundColor Cyan
Write-Host "------------------------"

Write-Host "`n--- Communication ---" -ForegroundColor Yellow
Install-WingetApp "SlackTechnologies.Slack" "Slack"
Install-WingetApp "Discord.Discord" "Discord"
Install-WingetApp "Zoom.Zoom" "Zoom"
Install-WingetApp "Microsoft.Teams" "Microsoft Teams"
Install-WingetApp "WhatsApp.WhatsApp" "WhatsApp"
Install-WingetApp "Telegram.TelegramDesktop" "Telegram"

Write-Host "`n--- Media ---" -ForegroundColor Yellow
Install-WingetApp "Spotify.Spotify" "Spotify"
Install-WingetApp "VideoLAN.VLC" "VLC Media Player"
Install-WingetApp "OBSProject.OBSStudio" "OBS Studio"
Install-WingetApp "Audacity.Audacity" "Audacity"
Install-WingetApp "BlenderFoundation.Blender" "Blender"
Install-WingetApp "Figma.Figma" "Figma"

Write-Host "`n--- Utilities & Games ---" -ForegroundColor Yellow
Install-WingetApp "Flameshot.Flameshot" "Flameshot (Screenshot Tool)"
Install-WingetApp "Valve.Steam" "Steam"

Write-Host "`nAll Apps Setup Complete! 🚀`n" -ForegroundColor Green
