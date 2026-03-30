# Author: Bhavin Pathak
# Description: Genesis Script - The Origin of Your Dev Environment (Windows)

$ErrorActionPreference = "Continue"

function Show-Menu {
    Clear-Host
    Write-Host "🪟 Windows Dev Env Bootstrap" -ForegroundColor Cyan
    Write-Host "https://github.com/Bhavin-Pathak/dev-env-bootstrap" -ForegroundColor DarkCyan
    Write-Host "--------------------------------------------------------" -ForegroundColor White
    Write-Host "Transform your fresh OS into a God-tier Dev Machine." -ForegroundColor White
    Write-Host "--------------------------------------------------------" -ForegroundColor White
    Write-Host "1.  Terminal Setup (OhMyPosh, Bat, Hack Fonts) 🎨" -ForegroundColor Yellow
    Write-Host "2.  Modern IDEs (VS Code, Cursor, Windsurf) 💻" -ForegroundColor Yellow
    Write-Host "3.  Web Browsers (Chrome, Brave, Edge) 🌐" -ForegroundColor Yellow
    Write-Host "4.  Node & Python Stack (NVM, Yarn, Bun) 🚀" -ForegroundColor Yellow
    Write-Host "5.  Mobile Development (Java 17, Flutter SDK, Android Studio) 📱" -ForegroundColor Yellow
    Write-Host "6.  DevOps & Cloud (Docker, AWS, Terraform) 🐳" -ForegroundColor Yellow
    Write-Host "7.  Database Suite (Postgres, Mongo, Redis) 🗄️" -ForegroundColor Yellow
    Write-Host "8.  API Testing Tools (Postman, Insomnia) 🔌" -ForegroundColor Yellow
    Write-Host "9.  Essential Apps (Slack, Discord, Spotify) 🛠️" -ForegroundColor Yellow
    Write-Host "10. System Maintenance (Temp, AppData) 🧹" -ForegroundColor Yellow
    Write-Host "11. Cloudflare WARP (VPN & DNS) 🛡️" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------" -ForegroundColor White
    Write-Host "0. Exit" -ForegroundColor Red
    Write-Host "--------------------------------------------------------" -ForegroundColor White
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    
    switch ($choice) {
        "1" { .\terminal.ps1 }
        "2" { .\ide.ps1 }
        "3" { .\browsers.ps1 }
        "4" { .\node-py.ps1 }
        "5" { .\java-flutter.ps1 }
        "6" { .\cloud-docker.ps1 }
        "7" { .\db-tools.ps1 }
        "8" { .\api-test.ps1 }
        "9" { .\essentials.ps1 }
        "10" { .\cleaner.ps1 }
        "11" { .\cloudflare-warp.ps1 }
        "0" { Write-Host "`nHappy Coding! 🚀" -ForegroundColor Green; exit }
        default { Write-Host "`nInvalid option. Please try again." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
    
    Write-Host "`nPress Enter to return to menu..." -ForegroundColor Cyan
    $null = Read-Host
}
