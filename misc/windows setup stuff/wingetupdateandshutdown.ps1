# ensure admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Start-Process -FilePath PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	exit
}

Write-Host "Upgrading all packages with winget, then shutting down."

Start-Process winget -ArgumentList "upgrade --all --silent --accept-source-agreements --accept-package-agreements authentication-mode silent" -Wait

Write-Host "All upgrades completed.. waiting 10 mins before shutdown!"

Start-Sleep -Seconds 600

Write-Host "Goodbye"

Stop-Computer -Force

