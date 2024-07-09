# Sanity checks
Invoke-ScriptAnalyzer -Path '.\AxcientAPI' -Recurse -ReportSummary
Invoke-ScriptAnalyzer -Path '.\AxcientAPI' -Recurse -ReportSummary -Fix

Write-Host "`nRebuilding Module..." -ForegroundColor Yellow
Build-Module -SourcePath '.\AxcientAPI\AxcientAPI.psd1' -OutputDirectory '..\Output' -UnversionedOutputDirectory

Write-Host "`nTesting Module..." -ForegroundColor Yellow
#Import-Module Pester -MinimumVersion 5.6.0
#Invoke-Pester -Path .\Tests -Output Detailed
.\Tests\test.ps1