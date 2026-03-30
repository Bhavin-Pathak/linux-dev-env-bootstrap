# Author: Bhavin Pathak
# Description: Ultimate Terminal Setup (Windows)

$ErrorActionPreference = "Continue"

function Write-Msg ($text) { Write-Host "`n>>> $text..." -ForegroundColor Cyan }

Clear-Host
Write-Host "Terminal Setup (Windows - Oh-My-Posh)" -ForegroundColor Cyan
Write-Host "------------------------"

Write-Msg "Installing Oh-My-Posh (Terminal Theme Engine)"
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-source-agreements --accept-package-agreements

Write-Msg "Installing Modern CLI Tools (bat, fzf)"
winget install sharkdp.bat --accept-source-agreements
winget install junegunn.fzf --accept-source-agreements

Write-Msg "Installing Nerd Fonts (Meslo)"
# Oh-My-Posh has a built in font installer
oh-my-posh font install meslo

Write-Msg "Configuring PowerShell Profile"
$profilePath = $PROFILE
if (-not (Test-Path -Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force > $null
}

if (-not (Select-String -Path $profilePath -Pattern "oh-my-posh init pwsh" -Quiet)) {
    Add-Content -Path $profilePath -Value "`n# Oh-My-Posh Configuration`n@(& oh-my-posh init pwsh --config `"$env:POSH_THEMES_PATH\jandedobbeleer.omp.json`") -invoke"
    Write-Host "✔ Added Oh-My-Posh to PowerShell Profile." -ForegroundColor Green
} else {
    Write-Host "✔ Oh-My-Posh is already in your profile." -ForegroundColor Green
}

if (-not (Select-String -Path $profilePath -Pattern "alias cat='bat'" -Quiet)) {
    Add-Content -Path $profilePath -Value "`n# Modern Aliases`nSet-Alias -Name cat -Value bat`nSet-Alias -Name ls -Value Get-ChildItem`nSet-Alias -Name ll -Value Get-ChildItem"
}

Write-Host "`n✨ Terminal Setup Complete! ✨" -ForegroundColor Green
Write-Host "Please download/install Windows Terminal from the Microsoft Store for the best experience." -ForegroundColor Yellow
Write-Host "Set the default font in Windows Terminal settings to 'MesloLGM Nerd Font'." -ForegroundColor Yellow
Write-Host "Restart your terminal to see changes.`n" -ForegroundColor Yellow
