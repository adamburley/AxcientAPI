param (
    [string]$Version
)

# Sanity checks
Invoke-ScriptAnalyzer -Path '.\AxcientAPI' -Recurse -ReportSummary
Invoke-ScriptAnalyzer -Path '.\AxcientAPI' -Recurse -ReportSummary -Fix
if ($Version) { Write-Host "Updating version to $Version" -ForegroundColor Yellow -BackgroundColor Blue }
Write-Host "`nRebuilding Module..." -ForegroundColor Yellow
Build-Module -Version $Version -SourcePath '.\AxcientAPI\AxcientAPI.psd1' -OutputDirectory '..\Output' -UnversionedOutputDirectory

Write-Host "`nTesting Module..." -ForegroundColor Yellow
#Import-Module Pester -MinimumVersion 5.6.0
#Invoke-Pester -Path .\Tests -Output Detailed
.\Tests\test.ps1

# Rebuild Docs
New-MarkdownHelp -Module AxcientAPI -OutputFolder .\docs -Force -NoMetadata -ExcludeDontShow