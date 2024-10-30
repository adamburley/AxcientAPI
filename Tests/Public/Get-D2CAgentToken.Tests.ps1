BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe "Get-D2CAgentToken" {
    BeforeAll {
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI { return @{ token_id = "mock-token-id" } }
        Mock -ModuleName AxcientAPI -CommandName Write-Error { }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Initialize-AxcientAPI -ApiKey 'pesterkey' -MockServer
    }

    It "Returns a PSCustomObject with the correct properties" {
        $result = Get-D2CAgentToken -Client 1 -Vault 1
        $result | Should -BeOfType [PSCustomObject]
        $result.client_id | Should -Be 1
        $result.vault_id | Should -Be 1
        $result.token_id | Should -Be "mock-token-id"
        $result.objectschema | Should -Be "d2c_agent_token"
    }

    It "Handles pipeline input for Client parameter" {
        $clients = 1..3
        $results = $clients | Get-D2CAgentToken -Vault 1
        $results.Count | Should -Be 3
        $results | ForEach-Object { $_.client_id | Should -BeIn 1,2,3 }
    }

    It "Uses Find-ObjectIdByReference for Client and Vault parameters" {
        Mock -ModuleName AxcientAPI -CommandName Find-ObjectIdByReference { if ($Reference -is [int]) { return $Reference} else { return $Reference.id }}
        $mockClient = [PSCustomObject]@{ id = 1; objectschema = 'client'}
        $mockVault = [PSCustomObject]@{ id=2; objectschema='vault'}
        Get-D2CAgentToken -Client $mockClient -Vault $mockVault
        Should -ModuleName AxcientAPI -Invoke Find-ObjectIdByReference -Times 1 -ParameterFilter { $Reference -eq $mockClient }
        Should -ModuleName AxcientAPI -Invoke Find-ObjectIdByReference -Times 1 -ParameterFilter { $Reference -eq $mockVault }
    }
    It 'Requires objects with the correct schema' {
        $mockClient = [PSCustomObject]@{ id = 1; objectschema = 'wrongclient'}
        { Get-D2CAgentToken -Client $mockClient -Vault 1 } | Should -Throw -ExpectedMessage 'Cannot validate argument on parameter ''Client''. Must be a positive integer or matching object' -ExceptionType ([System.Management.Automation.ParameterBindingException])
    }
    It "Calls Invoke-AxcientAPI with the correct parameters" {
        Get-D2CAgentToken -Client 1 -Vault 1
        Should -ModuleName AxcientAPI -Invoke Invoke-AxcientAPI -Times 1 -ParameterFilter {
            $Endpoint -eq "client/1/vault/1/d2c_agent" -and
            $Method -eq "Post"
        }
    }
    It "Returns a d2c_agent_token object by default, even when a client object is provided" {
        $clientObject = [PSCustomObject]@{ id = 12; objectschema = 'client' }
        $result = $clientObject | Get-D2CAgentToken -Vault 1
        $result.objectschema | Should -Be 'd2c_agent_token'
    }
    It "Adds d2c_token_id property to input object when -PassThru is used" {
        $clientObject = [PSCustomObject]@{ id = 12; objectschema = 'client' }
        $result = $clientObject | Get-D2CAgentToken -Vault 1 -PassThru
        $result.id | Should -Be 12
        $result.d2c_token_id | Should -Be "mock-token-id"
    }
    It "Doesn't modify the input object when it's not a PSCustomObject, even with -PassThru" {
        $result = Get-D2CAgentToken -Client 1 -Vault 1 -PassThru
        $result.objectschema | Should -Be 'd2c_agent_token'
    }
}