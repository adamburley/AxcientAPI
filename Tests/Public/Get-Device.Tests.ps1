BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}
 
Describe "Get-Device" {
    BeforeAll {
        Mock -ModuleName AxcientApi -CommandName Write-Error { }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Initialize-AxcientAPI -ApiKey "pesterapikey" -MockServer
        $clientObject = [PSCustomObject]@{
            Id_ = 2
            objectschema = 'client'
        }
        $deviceObject = [PSCustomObject]@{
            Id_ = 42
            objectschema = 'device'
        }
    }    
    Context "Parameter validation" {
        It "-Client supports a matching object" {
           Mock Get-Device { }
              {Get-Device -Client $clientObject } | Should -Not -Throw
        }
        It "-Client supports an integer" {
            Mock Get-Device { }
            { Get-Device -Client 2 } | Should -Not -Throw
        }
        It "-Client requires a matching object" {
            { Get-Device -Client $deviceObject } | Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'Client'. Must be a positive integer or matching object" -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
        It "-Device supports a matching object" {
            Mock Get-Device { }
            { Get-Device -Device $deviceObject } | Should -Not -Throw
        }
        It "-Device supports an integer" {
            Mock Get-Device { }
            { Get-Device -Device 42 } | Should -Not -Throw
        }
        It "-Device requires a matching object" {
            { Get-Device -Device $clientObject } | Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'Device'. Must be a positive integer or matching object" -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
    }

    Context "Call and response" {
        It "Parses and passes -Client [int]" {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            Get-Device -Client 2
            $InvocationEndpoint | Should -Be "client/2/device"
        }
        It "Parses and passes -Client [object]" {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            Get-Device -Client $clientObject
            $InvocationEndpoint | Should -Be "client/2/device"
        }
        It "Accepts a client object from the pipeline" {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            $clientObject | Get-Device
            $InvocationEndpoint | Should -Be "client/2/device"
        }
        It "Parses and passes -Device [int]" {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            Get-Device -Device 42
            $InvocationEndpoint | Should -Be "device/42"
        }
        It "Parses and passes -Device [object]" {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            Get-Device -Device $deviceObject
            $InvocationEndpoint | Should -Be "device/42"
        }
    }
}