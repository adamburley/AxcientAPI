BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe 'Get-VaultThreshold' {
    BeforeAll {
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
            New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            [PSCustomObject]@{
                threshold = 240
            }
        }
        Mock -ModuleName AxcientAPI -CommandName Write-Error { }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Initialize-AxcientAPI -ApiKey 'pesterapikey' -MockServer
    }

    Context 'Parameter validation' {
        It 'Accepts a Vault object' {
            $vaultObject = [PSCustomObject]@{
                id = 1
                objectschema = 'vault'
            }
            { Get-VaultThreshold -Vault $vaultObject } | Should -Not -Throw
        }

        It 'Accepts a Vault ID as integer' {
            { Get-VaultThreshold -Vault 1 } | Should -Not -Throw
        }

        It 'Throws an error for invalid Vault input' {
            { Get-VaultThreshold -Vault 'invalid' } | Should -Throw
        }
    }

    Context 'API interaction' {
        It 'Calls the correct API endpoint' {
            Get-VaultThreshold -Vault 1
            $InvocationEndpoint | Should -Be 'vault/1/threshold/connectivity'
        }

        It 'Passes the Vault ID from a Vault object' {
            $vaultObject = [PSCustomObject]@{
                id = 2
                objectschema = 'vault'
            }
            Get-VaultThreshold -Vault $vaultObject
            $InvocationEndpoint | Should -Be 'vault/2/threshold/connectivity'
        }
    }

    Context 'Output' {
        It 'Returns a vault.threshold object with correct properties' {
            $result = Get-VaultThreshold -Vault 12
            $result | Should -BeOfType [PSCustomObject]
            $result.vault_id | Should -Be 12
            $result.threshold | Should -Be 240
            $result.objectschema | Should -Be 'vault.threshold'
        }
        It 'Returns a vault.threshold object when passed an integer even with -PassThru set' {
            $result = Get-VaultThreshold -Vault 12 -PassThru
            $result | Should -BeOfType [PSCustomObject]
            $result.vault_id | Should -Be 12
            $result.threshold | Should -Be 240
            $result.objectschema | Should -Be 'vault.threshold'
        }
        It 'Returns a vault object when passed a vault object with -PassThru' {
            $testVault = [PSCustomObject]@{
                id = 42
                objectschema = 'vault'
                vault_thresholds = $null
            }
            $result = $testVault | Get-VaultThreshold -PassThru
            $result.objectschema | Should -Be 'vault'
            $result.vault_thresholds.connectivity_threshold | Should -Be 240
        }
        It 'Returns a vault object with -PassThru when an existing threshold exists' {
            $testVault = [PSCustomObject]@{
                id = 42
                objectschema = 'vault'
                vault_thresholds = [PSCustomObject]@{
                    capacity = 90
                }
            }
            $result = $testVault | Get-VaultThreshold -PassThru
            $result.objectschema | Should -Be 'vault'
            $result.vault_thresholds.connectivity_threshold | Should -Be 240
            $result.vault_thresholds.capacity | Should -Be 90
        }
    }
}
