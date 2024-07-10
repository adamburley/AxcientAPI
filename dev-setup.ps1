# Import this as a library. Import-Module .\dev-setup.ps1
# Sets up local development environment for AxcientAPI module.
Function Initialize-DevEnvironment {
# If developing for an Azure Function app with environment variables, import.
    if (Test-Path '.\local.settings.json') {
        $environmentVariables = Get-Content -Path '.\local.settings.json' | ConvertFrom-Json -depth 10 | Select-Object -expandproperty Values
        $environmentVariables | Get-Member -MemberType NoteProperty | Foreach-Object {
            $name = $_.Name
            New-Item -Path "Env:\$name" -Value $environmentVariables.$name -Force
        }
    }

    Write-Host "`nRebuilding Module..." -ForegroundColor Yellow
    Build-Module -SourcePath '.\AxcientAPI\AxcientAPI.psd1' -OutputDirectory '..\Output' -UnversionedOutputDirectory

    Write-Host "Importing module..." -ForegroundColor Yellow
    Import-Module -Name '.\Output\AxcientAPI' -Force

    # Module-specific initializations

    #Initialize-AxcientAPI -ApiKey $env:AxcientApiKey -MockServer
    Initialize-AxcientAPI -ApiKey ${env:AxcientApiKey-Prod} -ReturnErrors
}
Set-Alias -Name 'redo' -Value Initialize-DevEnvironment -Scope Global

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