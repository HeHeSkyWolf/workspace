param(
    [int]$DurationMinutes = 30,
    [int]$Port = 33021
)

$ruleName = "Gogs Gateway Temporary - TCP $Port"

$internalSubnets = @(
    "192.168.0.0/16",
    "10.0.0.0/8",
    "172.16.0.0/12"
)

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator!" -ErrorAction Stop
}

if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
    Remove-NetFirewallRule -DisplayName $ruleName
}

New-NetFirewallRule `
    -DisplayName $ruleName `
    -Direction Inbound `
    -Action Allow `
    -Protocol TCP `
    -LocalPort $Port `
    -RemoteAddress $internalSubnets `
    -Profile Private, Domain `
    -ErrorAction Stop

Write-Host "Rule '$ruleName' opened for internal subnets. Closing in $DurationMinutes minutes..." -ForegroundColor Green

try {
    Start-Sleep -Seconds ($DurationMinutes * 60)
} finally {
    Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    Write-Host "Rule '$ruleName' removed." -ForegroundColor Yellow
}
