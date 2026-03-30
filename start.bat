@echo off
echo Windows detected! Launching Windows Bootstrap...
cd windows
powershell -ExecutionPolicy Bypass -File "genesis.ps1"
cd ..
