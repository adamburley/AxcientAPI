BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe 'Get-Vault' {
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
        $vaultObject = [PSCustomObject]@{
            id           = 42
            objectschema = 'vault'
            client_id    = 2
        }
    }
    Context 'Input validation' {
        It 'Supports no parameters' {
            { Get-Vault } | Should -Not -Throw
        }
        It 'Supports a matching object parameter' {
            { Get-Vault -Vault $vaultObject } | Should -Not -Throw
        }
        It 'Supports a matching object via pipeline' {
            { $vaultObject | Get-Vault } | Should -Not -Throw
        }
        It 'Supports an integer' {
            { Get-Vault -Vault 42 } | Should -Not -Throw
        }
        It 'Requires a matching object' {
            $clientObject = [PSCustomObject]@{
                id           = 2
                objectschema = 'client'
            }
            { Get-Vault -Vault $clientObject } | Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'Vault'. Must be a positive integer or matching object" -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
        It 'Calls the correct endpoint with an integer vault ID' {
            Get-Vault -Vault 42
            $InvocationEndpoint | Should -Be 'vault/42'
        }
        It 'Calls the correct endpoint with a vault object' {
            Get-Vault -Vault $vaultObject
            $InvocationEndpoint | Should -Be 'vault/42'
        }
        It 'Calls the correct endpoint with -Type' {
            Get-Vault -Type 'Private'
            $InvocationEndpoint | Should -Be 'vault?type=Private'
        }
        It 'Calls the correct endpoint with -Active' {
            Get-Vault -Active $true
            $InvocationEndpoint | Should -Be 'vault?active=True'
        }
        It 'Calls the correct endpoint with -WithUrl' {
            Get-Vault -WithUrl $true
            $InvocationEndpoint | Should -Be 'vault?with_url=True'
        }
        It 'Calls the correct endpoint with -Limit' {
            Get-Vault -Limit 5
            $InvocationEndpoint | Should -Be 'vault?limit=5'
        }
        It 'Calls the correct endpoint with -IncludeDevices' {
            Get-Vault -IncludeDevices $false
            $InvocationEndpoint | Should -Be 'vault?include_devices=False'
        }
        It 'Calls the correct endpoint with multiple parameters' {
            Get-Vault -Type 'Private' -Active $true -WithUrl $true -Limit 5 -IncludeDevices $false
            $InvocationEndpoint | Should -Be 'vault?type=Private&active=True&with_url=True&limit=5&include_devices=False'
        }
    }
    Context 'Output validation' {
        It 'Appends objectschema for a single result' {
            $result = Get-Vault -Vault $vaultObject
            $result.objectschema | Should -Be 'vault'
        }
        It 'Appends objectschema for multiple results' {
            $vaultObject2 = [PSCustomObject]@{
                id           = 43
                objectschema = 'vault'
                client_id    = 3
            }
            $result = $vaultObject, $vaultObject2 | Get-Vault
            $result | Should -HaveCount 2
            $result | ForEach-Object { $_.objectschema  | Should -Be 'vault' }
        }
    }
}