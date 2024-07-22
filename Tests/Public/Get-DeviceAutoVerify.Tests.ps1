BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe 'Get-DeviceAutoVerify' {
    BeforeAll {
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
            New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            $testId = $Endpoint -replace 'device/(\d+)/autoverify', '$1'

            # Return a given number of results based on the modulus of the test ID
            $reply = for ($i = 0; $i -lt $testId % 4; $i++) {
                [PSCustomObject]@{
                    id = $testId + 10 + $i
                }
            }
            $reply
        }
        Mock -ModuleName AxcientAPI -CommandName Write-Error { }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Initialize-AxcientAPI -ApiKey 'pesterapikey' -MockServer
    }
    Describe 'Input validation' {
        It '-Device supports a matching object' {
            $deviceObject = [PSCustomObject]@{
                id           = 42
                objectschema = 'device'
            }
            { Get-DeviceAutoVerify -Device $deviceObject } | Should -Not -Throw
        }
        It '-Device supports an integer' {
            { Get-DeviceAutoVerify -Device 42 } | Should -Not -Throw
        }
        It '-Device requires a matching object schema' {
            $clientObject = [PSCustomObject]@{
                id           = 2
                objectschema = 'client'
            }
            { Get-DeviceAutoVerify -Device $clientObject } | Should -Throw -ExpectedMessage 'Cannot validate argument on parameter ''Device''. Must be a positive integer or matching object' -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
        It 'Calls the correct endpoint with an integer device ID' {
            Get-DeviceAutoVerify -Device 42
            $InvocationEndpoint | Should -Be 'device/42/autoverify'
        }
        It 'Calls the correct endpoint with a device object' {
            $deviceObject = [PSCustomObject]@{
                id           = 43
                objectschema = 'device'
            }
            Get-DeviceAutoVerify -Device $deviceObject
            $InvocationEndpoint | Should -Be 'device/43/autoverify'
        }
        It 'Correctly handles pipeline input' {
            $deviceObject = [PSCustomObject]@{
                id           = 40
                objectschema = 'device'
            }
            $deviceObject | Get-DeviceAutoVerify
            $InvocationEndpoint | Should -Be 'device/40/autoverify'
        }
        It 'Correctly handles multiple pipeline inputs' {
            $deviceObject1 = [PSCustomObject]@{
                id           = 41
                objectschema = 'device'
            }
            $deviceObject2 = [PSCustomObject]@{
                id           = 42
                objectschema = 'device'
            }
            $deviceObject1, $deviceObject2 | Get-DeviceAutoVerify
            InModuleScope -ModuleName AxcientAPI { Should -Invoke Invoke-AxcientAPI -Times 2 -Exactly }
        }
        It 'Correctly handles multiple property inputs' {
            $deviceObject1 = [PSCustomObject]@{
                id           = 41
                objectschema = 'device'
            }
            $deviceObject2 = [PSCustomObject]@{
                id           = 42
                objectschema = 'device'
            }
            $deviceObject1, $deviceObject2 | Get-DeviceAutoVerify
            InModuleScope -ModuleName AxcientAPI { Should -Invoke Invoke-AxcientAPI -Times 2 -Exactly }
        }
    }
    Describe 'Output validation' {
        It 'Appends device_id and client_id for a single result' {
            $dav = Get-DeviceAutoVerify -Device ([PSCustomObject]@{
                    id           = 41
                    client_id    = 2
                    objectschema = 'device'
                })
            $dav.client_id | Should -Be 2
            $dav.device_id | Should -Be 41
        }
        It 'Append device_id and client_id for multiple results' {
            $dav = Get-DeviceAutoVerify -Device ([PSCustomObject]@{
                    id           = 42
                    client_id    = 2
                    objectschema = 'device'
                })
            $dav | Should -HaveCount 2
            $dav | Foreach-Object {
                $_.client_id | Should -Be 2
                $_.device_id | Should -Be 42
            }
        }
        It 'Appends schema for a single result' {
            $dav = Get-DeviceAutoVerify -Device 41
            $dav.objectschema | Should -Be 'device.autoverify'
        }
        It "Appends schema for multiple results" {
            $dav = Get-DeviceAutoVerify -Device 42
            $dav | Should -HaveCount 2
            $dav | Foreach-Object { $_.objectschema | Should -Be 'device.autoverify' }
        }
    }
}