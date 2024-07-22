BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe 'Get-BackupJobHistory' {
    BeforeAll {
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {}
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Initialize-AxcientAPI -ApiKey 'pestertestkey' -MockServer
    }
    It 'Raises a warning about the endpoint bug' {
        Get-BackupJobHistory -Device 4321 -Client 1234 -Job 14
        InModuleScope -ModuleName AxcientAPI { Should -Invoke Write-Warning -ParameterFilter { $Message -eq 'This endpoint is bugged and unusable as of 2024-07-11, returning a missing path parameter error. Once this is resolved this function will be tested and this warning removed. See Issue #GH-3.' } }
    }
}