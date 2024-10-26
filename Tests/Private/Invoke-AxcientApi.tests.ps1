BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe "Invoke-AxcientAPI" {
    Context "Input validation" {
        It "Invokes the correct mock endpoint" {
            Initialize-AxcientAPI -ApiKey "pesterapikey" -MockServer
            Mock -ModuleName AxcientAPI -CommandName Invoke-WebRequest {
                New-Variable -Name InvocationEndpoint -Value $Uri -Scope Global -Force
            }
            InModuleScope AxcientAPI { 
                Invoke-AxcientAPI -Endpoint "client/2/device" -Method Get -ErrorAction SilentlyContinue
                $InvocationEndpoint | Should -Be "https://ax-pub-recover.wiremockapi.cloud/x360recover/client/2/device" 
            }
        }
        It "Invokes the correct production endpoint" {
            Initialize-AxcientAPI -ApiKey "pesterapikey"
            Mock -ModuleName AxcientAPI -CommandName Invoke-WebRequest {
                New-Variable -Name InvocationEndpoint -Value $Uri -Scope Global -Force
            }
            InModuleScope AxcientAPI { 
                Invoke-AxcientAPI -Endpoint "client/2/device" -Method Get -ErrorAction SilentlyContinue
                $InvocationEndpoint | Should -Be "https://axapi.axcient.com/x360recover/client/2/device" 
            }
        }
        It "Provides correct header information" {
            Initialize-AxcientAPI -ApiKey "pesterapikey" -MockServer
            Mock -ModuleName AxcientAPI -CommandName Invoke-WebRequest {
                New-Variable -Name Headers -Value $Headers -Scope Global -Force
            }
            InModuleScope AxcientAPI { 
                Invoke-AxcientAPI -Endpoint "client/2/device" -Method Get -ErrorAction SilentlyContinue
                $Headers.'X-API-Key' | Should -Be "pesterapikey"
                $Headers.'Accept' | Should -Be "application/json"
            }
        }
        It "Invokes the correct HTTP method" {
            Initialize-AxcientAPI -ApiKey "pesterapikey" -MockServer
            Mock -ModuleName AxcientAPI -CommandName Invoke-WebRequest {
                New-Variable -Name IWRMethod -Value $Method -Scope Global -Force
            }
            InModuleScope AxcientAPI { 
                Invoke-AxcientAPI -Endpoint "client/2/device" -Method Get -ErrorAction SilentlyContinue
                $IWRMethod | Should -Be 'Get'
            }
        }
        It "Detects return error setting" {
            Initialize-AxcientAPI -ApiKey 'pesterapikey' -MockServer -ReturnErrors
            InModuleScope AxcientAPI { 
                $Response = Invoke-AxcientAPI -Endpoint "client/2/device/device" -Method Get -ErrorAction SilentlyContinue
                $Response.Status | Should -Be 404
                $Response.Type | Should -Be 'UndefiniedHTTPErrorResponse'
            }
        }
    }
    Context "Error handling" {
        # Leaving this and other validation until the API format is closer to production.
    }
}