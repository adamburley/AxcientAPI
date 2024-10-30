BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}
 
Describe "Get-Device" {
    BeforeAll {
        Mock -ModuleName AxcientApi -CommandName Write-Error { }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Initialize-AxcientAPI -ApiKey "pesterapikey" -MockServer
        $clientObject = [PSCustomObject]@{
            id           = 2
            objectschema = 'client'
        }
        $deviceObject = [PSCustomObject]@{
            id           = 42
            objectschema = 'device'
        }
    }    
    Context "Parameter validation" {
        It "-Client supports a matching object" {
            { Get-Device -Client $clientObject } | Should -Not -Throw
        }
        It "-Client supports an integer" {
            { Get-Device -Client 2 } | Should -Not -Throw
        }
        It "-Client requires a matching object" {
            { Get-Device -Client $deviceObject } | Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'Client'. Must be a positive integer or matching object" -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
        It "-Device supports a matching object" {
            { Get-Device -Device $deviceObject } | Should -Not -Throw
        }
        It "-Device supports an integer" {
            { Get-Device -Device 42 } | Should -Not -Throw
        }
        It "-Device requires a matching object" {
            { Get-Device -Device $clientObject } | Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'Device'. Must be a positive integer or matching object" -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
        It "ServiceId requires length = 4" {
            { Get-Device -Client 2 -ServiceId 'asdf' } | Should -Not -Throw
            { Get-Device -Client 2 -ServiceId 'as' } | Should -Throw
            { Get-Device -Client 2 -ServiceId 'asdfqwe' } | Should -Throw
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
        It "Passes a Service ID to a query parameter" {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            Get-Device -Client 12 -ServiceId 'baby'
            $InvocationEndpoint | Should -Be 'client/12/device?service_id=baby'
        }
        It 'Passes D2C Only to a query parameter' {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            Get-Device -Client 42 -D2COnly
            $InvocationEndpoint | Should -Be 'client/42/device?d2c_only=true'
        }
        It 'Ignores D2C if Service ID is specified' {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            Get-Device -Client 33 -ServiceId 'asdf' -D2COnly
            Should -ModuleName AxcientAPI -Invoke Write-Warning -Times 1 -ParameterFilter { $Message -eq 'Only one of service_id and d2c_only may be specified. Ignoring d2c_only switch.' }
            $InvocationEndpoint | Should -Be 'client/33/device?service_id=asdf'
            
        }
    }
    Context 'Pagination' {
        BeforeAll {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
                if ($Endpoint -eq 'device?limit=100&offset=0') {
                    0..99 | % { [PSCustomObject]@{ id = $_ } }
                }
                elseif ($Endpoint -eq 'device?limit=100&offset=100') {
                    100..199 | % { [PSCustomObject]@{ id = $_ } }
                }
                else {
                    200..220 | % { [PSCustomObject]@{ id = $_ } }
                }
            }
        }
        It 'Does not paginate on Device/{device_id} calls' {
            Get-Device -Device 12
            $InvocationEndpoint | Should -Be 'device/12'
            Should -ModuleName AxcientAPI -Invoke Invoke-AxcientAPI -Times 1
        }
        It 'Does not paginate on client/{client_id}/device calls' {
            Get-Device -Client 2
            $InvocationEndpoint | Should -Be 'client/2/device'
            Should -ModuleName AxcientAPI -Invoke Invoke-AxcientAPI -Times 1
        }
        It 'Retrieves all results on client/ calls' {
            $allDevices = Get-Device
            $allDevices | Should -HaveCount 221
            Should -ModuleName AxcientAPI -Invoke Invoke-AxcientAPI -Times 3
        }
        It 'Does not page more than needed if total results < 100' {
            Mock -ModuleName AxcientAPI Invoke-AxcientAPI {
                0..22 | % { [PSCustomObject]@{ id = $_ } }
            }
            $allDevices = Get-Device
            $allDevices | Should -HaveCount 23
            Should -ModuleName AxcientAPI -Invoke Invoke-AxcientAPI -Times 1
        }
        It 'Does not paginate on error' {
            Mock -ModuleName AxcientAPI Invoke-AxcientAPI { }
            $allDevices = Get-Device
            $allDevices | Should -Be $null
            Should -ModuleName AxcientAPI -Invoke Invoke-AxcientAPI -Times 1
        }
    }
}