BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe 'Get-Appliance' {
    BeforeAll {
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
            New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            [PSCustomObject]@{
                id = 2
            }
        }
        Mock -ModuleName AxcientAPI -CommandName Write-Error { }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Initialize-AxcientAPI -ApiKey 'pesterapikey' -MockServer
    }
    Context 'Input validation' {
        It '-Appliance supports a matching object' {
            $applianceObject = [PSCustomObject]@{
                id           = 42
                objectschema = 'appliance'
            }
            { Get-Appliance -Appliance $applianceObject } | Should -Not -Throw
        }
        It '-Appliance supports an integer' {
            { Get-Appliance -Appliance 42 } | Should -Not -Throw
        }
        It '-Appliance requires a matching object schema' {
            $clientObject = [PSCustomObject]@{
                id           = 2
                objectschema = 'client'
            }
            { Get-Appliance -Appliance $clientObject } | Should -Throw -ExpectedMessage 'Cannot validate argument on parameter ''Appliance''. Must be a positive integer or matching object' -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
        It '-Client supports a matching object' {
            $clientObject = [PSCustomObject]@{
                id           = 42
                objectschema = 'client'
            }
            { Get-Appliance -Client $clientObject } | Should -Not -Throw
        }
        It '-Client supports an integer' {
            { Get-Appliance -Client 42 } | Should -Not -Throw
        }
        It '-Client requires a matching object schema' {
            $deviceObject = [PSCustomObject]@{
                id           = 2
                objectschema = 'device'
            }
            { Get-Appliance -Client $deviceObject } | Should -Throw -ExpectedMessage 'Cannot validate argument on parameter ''Client''. Must be a positive integer or matching object' -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
        It '-ServiceID supports a 4-character alphanumeric string' {
            { Get-Appliance -ServiceID 'abcd' } | Should -Not -Throw
        }
        It '-ServiceID requires a 4-character alphanumeric string' {
            { Get-Appliance -ServiceID 'abcde' } | Should -Throw -ExpectedMessage 'Cannot validate argument on parameter ''ServiceID''. Service ID must be a 4-character alphanumeric string' -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
    }
    Context 'Parameter set selection' {
        It 'Calls the correct endpoint with no parameters' {
            Get-Appliance
            $InvocationEndpoint | Should -Be 'appliance'
        }
        It 'Calls the correct endpoint with an appliance' {
            $applianceObject = [PSCustomObject]@{
                id           = 42
                objectschema = 'appliance'
            }
            Get-Appliance -Appliance $applianceObject
            $InvocationEndpoint | Should -Be 'appliance/42'
        }
        It 'Calls the correct endpoint with a client' {
            $clientObject = [PSCustomObject]@{
                id           = 42
                objectschema = 'client'
            }
            Get-Appliance -Client $clientObject
            $InvocationEndpoint | Should -Be 'client/42/appliance'
        }
        It 'Calls the correct endpoint with a service ID' {
            Get-Appliance -ServiceID 'abcd'
            $InvocationEndpoint | Should -Be 'appliance?service_id=abcd'
        }
        It 'Calls the correct endpoint with include devices' {
            Get-Appliance -IncludeDevices $true
            $InvocationEndpoint | Should -Be 'appliance?include_devices=True'
        }
        It 'Calls the correct endpoint when pipelining an appliance' {
            $applianceObject = [PSCustomObject]@{
                id           = 42
                objectschema = 'appliance'
            }
            $applianceObject | Get-Appliance
            $InvocationEndpoint | Should -Be 'appliance/42'
        }
        It 'Calls the correct endpoint when pipelining a client' {
            $clientObject = [PSCustomObject]@{
                id           = 42
                objectschema = 'client'
            }
            $clientObject | Get-Appliance
            $InvocationEndpoint | Should -Be 'client/42/appliance'
        }
    }
    Context 'Output validation' {
        It 'Appends schema for a single result' {
            $dav = Get-Appliance -Appliance 41
            $dav.objectschema | Should -Be 'appliance'
        }
        It "Appends schema for multiple results" {
            $applianceObject = [PSCustomObject]@{
                id           = 42
                objectschema = 'appliance'
            }
            $dav = $applianceObject,$applianceObject | Get-Appliance 
            $dav | Should -HaveCount 2
            $dav | Foreach-Object { $_.objectschema | Should -Be 'appliance' }
        }
    }
}