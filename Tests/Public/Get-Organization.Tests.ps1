BeforeAll {
   Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe "Get-Organization" {
    BeforeAll {
        Initialize-AxcientAPI -ApiKey "pesterapikey" -MockServer
        $organization = Get-Organization
    }
    It "should return an organization object" {
        $organization | Should -BeOfType [PSCustomObject]
    }
    It "should return an object with the correct schema" {
        $organization.objectschema | Should -Be 'organization'
    }
}