# Author: Bhavin Pathak
# Description: Cloudflare WARP Setup (Windows)

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

function Install-Warp {
    Write-Msg "Installing Cloudflare WARP"
    winget install --id Cloudflare.Warp -e --accept-source-agreements --accept-package-agreements
    Start-Sleep -Seconds 5
    Write-Host "✔ Cloudflare WARP Installed." -ForegroundColor Green
}

function Setup-Warp {
    Write-Msg "Cloudflare WARP Configuration"
    if (-not (Get-Command warp-cli -ErrorAction SilentlyContinue)) {
        Write-Host "warp-cli not found yet. Please restart terminal or use the GUI." -ForegroundColor Yellow
        return
    }
    
    $reg = Read-Host "Register New Client? [y/n]"
    if ($reg -match "^[yY]") { warp-cli register }

    $conn = Read-Host "Connect Client? [y/n]"
    if ($conn -match "^[yY]") { warp-cli connect }

    Write-Host "`nTesting Connection..." -ForegroundColor Green
    Invoke-RestMethod https://www.cloudflare.com/cdn-cgi/trace | Select-String "warp="
}

Clear-Host
Write-Host "Cloudflare WARP Setup (Windows)" -ForegroundColor Cyan
Write-Host "------------------------"

$isInstalled = winget list --id Cloudflare.Warp -e | Out-String
if ($isInstalled -match "Cloudflare.Warp") {
    Write-Host "✔ Cloudflare WARP is already installed." -ForegroundColor Green
    $configAgain = Read-Host "Do you want to run setup/config again? [y/n]"
    if ($configAgain -match "^[yY]") { Setup-Warp }
} else {
    if (Ask-Install "Cloudflare WARP") {
        Install-Warp
        Setup-Warp
    }
}
Write-Host "`nWARP Setup Complete! 🚀`n" -ForegroundColor Green
