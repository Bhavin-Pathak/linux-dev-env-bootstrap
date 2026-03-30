# Author: Bhavin Pathak
# Description: Docker & Cloud DevOps Tools Installer (Windows)

$ErrorActionPreference = "Stop"

function Write-Msg ($text) {
    Write-Host "`n>>> $text..." -ForegroundColor Cyan
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
    param($id, $name, $cmd)
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
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
Write-Host "Cloud & Containers Setup (Windows)" -ForegroundColor Cyan
Write-Host "---------------------------"

Install-WingetApp "Docker.DockerDesktop" "Docker Desktop" "docker"

Write-Host "`n--- Cloud Tools ---" -ForegroundColor Yellow
Install-WingetApp "Amazon.AWSCLI" "AWS CLI v2" "aws"
Install-WingetApp "Hashicorp.Terraform" "Terraform" "terraform"
Install-WingetApp "Kubernetes.kubectl" "Kubectl" "kubectl"
Install-WingetApp "Microsoft.AzureCLI" "Azure CLI" "az"

if (-not (Get-Command ansible -ErrorAction SilentlyContinue)) {
    if (Ask-Install "Ansible (via pip)") {
        Write-Msg "Installing Ansible via Python"
        if (Get-Command pip -ErrorAction SilentlyContinue) {
            pip install ansible
            Write-Host "✔ Ansible Installed." -ForegroundColor Green
        } else {
            Write-Host "Python/pip is not installed. Please run node-py.ps1 first." -ForegroundColor Red
        }
    }
} else {
    Write-Host "✔ Ansible is already installed." -ForegroundColor Green
}

Write-Host "`nSetup Complete! ☁️`n" -ForegroundColor Green
