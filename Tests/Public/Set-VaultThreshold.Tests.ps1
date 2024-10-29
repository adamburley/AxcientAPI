BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe 'Set-VaultThreshold' {
    BeforeAll {
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
            New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
            New-Variable -Name InvocationMethod -Value $Method -Scope Script -Force
            New-Variable -Name InvocationBody -Value $Body -Scope Script -Force
            [PSCustomObject]@{
                threshold = 60
            }
        }
        Mock -ModuleName AxcientAPI -CommandName Write-Error { }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Initialize-AxcientAPI -ApiKey 'pesterapikey' -MockServer
    }
    Context 'Parameter validation' {
        It 'Should throw when Vault is invalid' {
            #Mock -ModuleName AxcientAPI Find-ObjectIdByReference { throw 'Invalid vault' }
            { Set-VaultThreshold -Vault 'InvalidVault' -ThresholdMinutes 60 } | 
                Should -Throw 'Cannot validate argument on parameter ''Vault''. Must be a positive integer or matching object'
        }

        It 'Should throw when ThresholdMinutes is less than 1' {
            { Set-VaultThreshold -Vault 1 -ThresholdMinutes 0 } | 
                Should -Throw 'Cannot validate argument on parameter ''ThresholdMinutes''. The 0 argument is less than the minimum allowed range of 1. Supply an argument that is greater than or equal to 1 and then try the command again.'
        }

        It 'Should not throw when parameters are valid' {
            { Set-VaultThreshold -Vault 1 -ThresholdMinutes 60 } | 
                Should -Not -Throw
        }
        It 'Accepts a Vault object' {
            $vaultObject = [PSCustomObject]@{
                id = 1
                objectschema = 'vault'
            }
            { Set-VaultThreshold -Vault $vaultObject -ThresholdMinutes 60 } | Should -Not -Throw
        }

        It 'Accepts a Vault ID as integer' {
            { Set-VaultThreshold -Vault 1  -ThresholdMinutes 60 } | Should -Not -Throw
        }
    }

    Context 'API interaction' {
        It 'Should call Find-ObjectIdByReference' {
            Mock -ModuleName AxcientAPI Find-ObjectIdByReference { return 123 }
            Set-VaultThreshold -Vault 1 -ThresholdMinutes 60
            Should -ModuleName AxcientAPI -Invoke Find-ObjectIdByReference -Times 1 -ParameterFilter { $Reference -eq 1 }
        }

        It 'Should call Invoke-AxcientAPI with correct parameters' {
            Set-VaultThreshold -Vault 1 -ThresholdMinutes 60
            Should -Invoke Invoke-AxcientAPI -ModuleName AxcientAPI -Times 1 
            $InvocationEndpoint | Should -Be 'vault/1/threshold/connectivity'
            $InvocationMethod | Should -Be 'Post'
            $InvocationBody.threshold | Should -Be 60
        }
    }
    Context 'Output' {
        It 'Returns a vault.threshold object with correct properties' {
            $result = Set-VaultThreshold -Vault 12 -ThresholdMinutes 60
            $result | Should -BeOfType [PSCustomObject]
            $result.vault_id | Should -Be 12
            $result.threshold | Should -Be 60
            $result.objectschema | Should -Be 'vault.threshold'
        }
        It 'Returns a vault.threshold object when passed an integer even with -PassThru set' {
            $result = Set-VaultThreshold -Vault 12 -ThresholdMinutes 60
            $result | Should -BeOfType [PSCustomObject]
            $result.vault_id | Should -Be 12
            $result.threshold | Should -Be 60
            $result.objectschema | Should -Be 'vault.threshold'
        }
        It 'Returns a vault object when passed a vault object with -PassThru' {
            $testVault = [PSCustomObject]@{
                id = 42
                objectschema = 'vault'
                vault_thresholds = $null
            }
            $result = $testVault | Set-VaultThreshold -ThresholdMinutes 60 -PassThru
            $result.objectschema | Should -Be 'vault'
            $result.vault_thresholds.connectivity_threshold | Should -Be 60
        }
        It 'Returns a vault object with -PassThru when an existing threshold exists' {
            $testVault = [PSCustomObject]@{
                id = 42
                objectschema = 'vault'
                vault_thresholds = [PSCustomObject]@{
                    capacity = 90
                }
            }
            $result = $testVault | Set-VaultThreshold -PassThru -ThresholdMinutes 60
            $result.objectschema | Should -Be 'vault'
            $result.vault_thresholds.connectivity_threshold | Should -Be 60
            $result.vault_thresholds.capacity | Should -Be 90
        }
    }

    Context 'Type parameter' {
        It 'Should use default Type when not specified' {
            Set-VaultThreshold -Vault 1 -ThresholdMinutes 60
            Should -Invoke Invoke-AxcientAPI -ModuleName AxcientAPI -Times 1
            $InvocationEndpoint | Should -Be 'vault/1/threshold/connectivity'
        }

        It 'Should use specified Type when provided' {
            Set-VaultThreshold -Vault 1 -ThresholdMinutes 60
            Should -Invoke Invoke-AxcientAPI -ModuleName AxcientAPI -Times 1
            $InvocationEndpoint | Should -Be 'vault/1/threshold/connectivity'
        }

        It 'Should not permit other Type values' {
             { Set-VaultThreshold -Vault 1 -ThresholdMinutes 60 -Type 'Capacity' } | Should -Throw 'Cannot validate argument on parameter ''Type''. The argument "Capacity" does not belong to the set "Connectivity" specified by the ValidateSet attribute. Supply an argument that is in the set and then try the command again.'
        }
    }
}
