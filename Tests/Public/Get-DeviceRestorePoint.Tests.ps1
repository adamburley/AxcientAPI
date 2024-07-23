BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe "Get-DeviceRestorePoint" {
    BeforeAll {
        Mock -ModuleName AxcientApi -CommandName Write-Error { }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
            New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            [PSCustomObject]@{
                id = 423
            }
        }
        Initialize-AxcientAPI -ApiKey "pesterapikey" -MockServer
        $deviceObject = [PSCustomObject]@{
            id           = 42
            objectschema = 'device'
            client_id    = 2
        }
    }
    Context "Parameter Validation" {
        It "-Device supports a matching object" {
            { Get-DeviceRestorePoint -Device $deviceObject } | Should -Not -Throw
        }
        It "-Device supports an integer" {
            { Get-DeviceRestorePoint -Device 42 } | Should -Not -Throw
        }
        It "-Device requires a matching object" {
            $clientObject = [PSCustomObject]@{
                id           = 2
                objectschema = 'client'
            }
            { Get-DeviceRestorePoint -Device $clientObject } | Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'Device'. Must be a positive integer or matching object" -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
        It 'Calls the correct endpoint with an integer device ID' {
            Get-DeviceRestorePoint -Device 42
            $InvocationEndpoint | Should -Be 'device/42/restore_point'
        }
        It 'Calls the correct endpoint with a device object' {
            Get-DeviceRestorePoint -Device $deviceObject
            $InvocationEndpoint | Should -Be 'device/42/restore_point'
        }
        It 'Correctly handles pipeline input' {
            $deviceObject | Get-DeviceRestorePoint
            $InvocationEndpoint | Should -Be 'device/42/restore_point'
        }
        It 'Correctly handles multiple inputs from the pipeline' {
            $deviceObject2 = [PSCustomObject]@{
                id           = 43
                objectschema = 'device'
                client_id    = 3
            }
            $deviceObject, $deviceObject2 | Get-DeviceRestorePoint
            InModuleScope -ModuleName AxcientAPI { Should -Invoke Invoke-AxcientAPI -Times 2 -Exactly }
        }
        It 'Correctly handles multiple inputs from the parameter' {
            $deviceObject2 = [PSCustomObject]@{
                id           = 43
                objectschema = 'device'
                client_id    = 3
            }
            Get-DeviceRestorePoint -Device $deviceObject, $deviceObject2
            InModuleScope -ModuleName AxcientAPI { Should -Invoke Invoke-AxcientAPI -Times 2 -Exactly }
        }
    }
    Context 'Output validation' {
        It 'Appends device_id and client_id for a single result' {
            $result = Get-DeviceRestorePoint -Device $deviceObject
            $result.client_id | Should -Be 2
            $result.device_id | Should -Be 42
        }
        It 'Appends device_id and client_id for multiple results' {
            $deviceObject2 = [PSCustomObject]@{
                id           = 43
                objectschema = 'device'
                client_id    = 3
            }
            $result = Get-DeviceRestorePoint -Device $deviceObject, $deviceObject2
            $result[0].client_id | Should -Be 2
            $result[0].device_id | Should -Be 42
            $result[1].client_id | Should -Be 3
            $result[1].device_id | Should -Be 43
        }
        It 'Appends objectschema for a single result' {
            $result = Get-DeviceRestorePoint -Device $deviceObject
            $result.objectschema | Should -Be 'device.restorepoint'
        }
        It 'Appends objectschema for multiple results' {
            $deviceObject2 = [PSCustomObject]@{
                id           = 43
                objectschema = 'device'
                client_id    = 3
            }
            $result = Get-DeviceRestorePoint -Device $deviceObject, $deviceObject2
            $result | Should -HaveCount 2
            $result | ForEach-Object { $_.objectschema  | Should -Be 'device.restorepoint' }
        }
    }
}