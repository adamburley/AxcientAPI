BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe "Initialize-AxcientAPI" {
    It "should set the given API key as a script variable" {
        Initialize-AxcientAPI -ApiKey "89ac2a90-3c3c-4038-b2e5-e1d3ec8fa92e-pestermock"
        InModuleScope -ModuleName AxcientAPI {
            $AxcientApiKey | Should -Be "89ac2a90-3c3c-4038-b2e5-e1d3ec8fa92e-pestermock"
        }
    }
    It "should set the production URL as a script variable" {
        Initialize-AxcientAPI -ApiKey "pesterapikey"
        InModuleScope -ModuleName AxcientAPI {
            $AxcientBaseUrl | Should -Be 'https://axapi.axcient.com/x360recover'
        }
    }
    It "should set the mock URL as a script variable" {
        Initialize-AxcientAPI -ApiKey "pesterapikey" -MockServer
        InModuleScope -ModuleName AxcientAPI {
            $AxcientBaseUrl | Should -Be "https://ax-pub-recover.wiremockapi.cloud"
        }
    }
}