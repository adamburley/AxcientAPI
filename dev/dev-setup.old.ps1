# Import this as a library. Import-Module .\dev-setup.ps1
# Sets up local development environment for AxcientAPI module.


redo

# Check if all needed modules are present.
@(
    @{ Name = 'Pester'; MinimumVersion = '5.6.0' }
    @{ Name = 'PSScriptAnalyzer'; MinimumVersion = '1.22.0' }
) | ForEach-Object {
    $module = Get-Module -Name $_.Name -ListAvailable
    if ($module -eq $null) {
        Write-Host "PowerShell Module $($_.Name) not found. Please install it." -ForegroundColor Red
    } elseif (($module.Version | Sort-Object -Descending | Select-Object -First 1) -lt $_.MinimumVersion) {
        Write-Host "PowerShell Module $($_.Name) version $($module.Version) is less than required version $($_.MinimumVersion). Please update it." -ForegroundColor Red
    }
}

$env:DevMode = 1
Write-Host "Dev mode enabled." -ForegroundColor Magenta