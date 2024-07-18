BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe 'Get-Client' {
    BeforeAll {
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
            New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            if ($Endpoint -eq 'client/111') {
                [PSCustomObject]@{
                    Id_ = 111
                }
            }
            elseif ($Endpoint -eq 'client/222') {
                @([PSCustomObject]@{
                        Id_ = 223
                    },
                    [PSCustomObject]@{
                        Id_ = 224
                    }
                )
            }
        }
        Mock -ModuleName AxcientApi -CommandName Write-Error { }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }

        Initialize-AxcientAPI -ApiKey 'pesterapikey' -MockServer
        
        $clientObject = [PSCustomObject]@{
            Id_          = 2
            objectschema = 'client'
        }
        $deviceObject = [PSCustomObject]@{
            Id_          = 42
            objectschema = 'device'
        }
    }
    Context "Parameter validation" {
        It 'Accepts blank input' {
            { Get-Client } | Should -Not -Throw
        }
        It "-Client supports a matching object" {
            { Get-Client -Client $clientObject } | Should -Not -Throw
        }
        It "-Client supports multiple objects" {
            { Get-Client -Client $clientObject, $clientObject } | Should -Not -Throw
        }
        It "-Client supports an integer" {
            { Get-Client -Client 2 } | Should -Not -Throw
        }
        It "-Client requires a matching object" {
            { Get-Client -Client $deviceObject } | Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'Client'. Must be a positive integer or matching object" -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
        It "-IncludeAppliances updates the called URI" {
            Get-Client -IncludeAppliances
            $InvocationEndpoint | Should -BeLike '*?include_appliances=true'
        }
    }
    Context "Call and response" {
        It "Calls the URI for all clients" {
            Get-Client
            $InvocationEndpoint | Should -Be "client"
        }
        It "Parses and passes -Client [int]" {

            Get-Client -Client 2
            $InvocationEndpoint | Should -Be "client/2"
        }
        It "Parses and passes -Client [object]" {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            Get-Client -Client $clientObject
            $InvocationEndpoint | Should -Be "client/2"
        }
        It "Accepts a client object from the pipeline" {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            }
            $clientObject | Get-Client
            $InvocationEndpoint | Should -Be "client/2"
        }
        It "Formats a correct URI for a single client and -IncludeAppliances" {
            Get-Client -Client 2 -IncludeAppliances
            $InvocationEndpoint | Should -Be "client/2?include_appliances=true"
        }
        It "Appends schema for a single result" {
            $result = Get-Client -Client 111
            $result.objectschema | Should -Be 'client'
        } 
        It "Appends schema for multiple results" {
            $result = Get-Client -Client 222
            $result | Should -HaveCount 2
            $result | Foreach-Object { $_.objectschema | Should -Be 'client' }
        }
    }
}