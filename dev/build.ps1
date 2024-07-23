# Execute from the repo root
# Usage: .\buildtools\build.ps1 -Version 1.0.0

param (
    [string]$Version
)

# Sanity checks
Invoke-ScriptAnalyzer -Path '.\AxcientAPI' -Recurse -ReportSummary
Invoke-ScriptAnalyzer -Path '.\AxcientAPI' -Recurse -ReportSummary -Fix
if ($Version) { 
    Write-Host "Updating version to $Version" -ForegroundColor Yellow -BackgroundColor Blue
    Update-ModuleManifest -Path '.\AxcientAPI\AxcientAPI.psd1' -ModuleVersion $Version
} else {
    $Version = (Test-ModuleManifest .\AxcientAPI\AxcientAPI.psd1).Version.ToString()
    Write-Host "Using version $Version" -ForegroundColor Yellow -BackgroundColor Blue

}
Write-Host "`nRebuilding Module..." -ForegroundColor Yellow
Build-Module -Version $Version -SourcePath '.\AxcientAPI\AxcientAPI.psd1' -OutputDirectory '..\Output' -UnversionedOutputDirectory

Write-Host "`nTesting Module..." -ForegroundColor Yellow
$pesterResults = & .\dev\test.ps1

# Rebuild Docs
New-MarkdownHelp -Module AxcientAPI -OutputFolder .\docs -NoMetadata -ExcludeDontShow -Force

# Readme Updates
$ReadmeContent = Get-Content -Path '.\README.md' -Raw

# Update Code coverage icon
# Thanks to https://wragg.io/add-a-code-coverage-badge-to-your-powershell-deployment-pipeline/
$codeCoverage = [math]::Round($pesterResults.CodeCoverage.CoveragePercent)
$BadgeColor = switch ($codeCoverage) {
    {$_ -in 90..100} { 'brightgreen' }
    {$_ -in 75..89}  { 'yellow' }
    {$_ -in 60..74}  { 'orange' }
    default          { 'red' }
}

$ReadmeContent = $ReadmeContent -replace "\!\[Code Coverage\]\(.*?\)", "![Code Coverage](https://img.shields.io/badge/coverage-$CodeCoverage%25-$BadgeColor.svg?maxAge=60)"

# Create summary page
$summaryContent = "## Functions`n`n"
$docFiles = Get-ChildItem -Path '.\docs' -File
foreach ($file in $docFiles) {
    $fileName = $file.BaseName
    $fileLink = "[${fileName}](./docs/${fileName})"
    $summaryContent += "- ${fileLink}`n"
}
$summaryContent += "`n#"
$ReadmeContent = [regex]::Replace($ReadmeContent,"## Functions\n\n(?'helpfiles'.*?)\n\n#{1}",$summaryContent,[System.Text.RegularExpressions.RegexOptions]::Singleline)

$ReadmeContent | Set-Content -Path '.\README.md'