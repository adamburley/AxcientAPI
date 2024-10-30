BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe 'Get-BackupJobHistory' {
    BeforeAll {
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI { return [PSCustomObject]@{id = 12 } }
        Mock -ModuleName AxcientAPI -CommandName Write-Warning { }
        Mock -ModuleName AxcientAPI -CommandName Write-Error { }
        Initialize-AxcientAPI -ApiKey 'pestertestkey' -MockServer
    }
    
    It 'Should call Invoke-AxcientAPI with correct parameters' {
        $job = [PSCustomObject]@{
            client_id    = 1
            device_id    = 2
            id           = 3
            objectschema = 'job'
        }
    
        Get-BackupJobHistory -Job $job
    
        Should -Invoke Invoke-AxcientAPI -ModuleName AxcientAPI -ParameterFilter {
            $Endpoint -eq 'client/1/device/2/job/3/history?&limit=1500&offset=0' -and
            $Method -eq 'Get'
        }
    }
    
    It 'Should add additional properties to the returned objects' {
        $job = [PSCustomObject]@{
            client_id    = 1
            device_id    = 2
            id           = 3
            objectschema = 'job'
        }
    
        $result = Get-BackupJobHistory -Job $job
    
        $result.client_id | Should -Be 1
        $result.device_id | Should -Be 2
        $result.job_id | Should -Be 3
        $result.objectschema | Should -Be 'job.history'
    }
    
    It 'Should throw an error when missing required IDs' {
        $job = [PSCustomObject]@{
            client_id    = 1

            objectschema = 'job'
        }
    
        Get-BackupJobHistory -Job $job | Should -Be $null
        InModuleScope AxcientAPI { Should -Invoke Write-Error -ParameterFilter { $Message -eq 'Missing client ID, device ID, or job ID. All three are required and may be included in the Job object or specified as parameters.' } }
    }
    
    It 'Should accept Device and Client parameters' {
        Get-BackupJobHistory -Device 1 -Client 2 -Job 3
    
        Should -Invoke Invoke-AxcientAPI -ModuleName AxcientAPI -ParameterFilter {
            $Endpoint -eq 'client/2/device/1/job/3/history?&limit=1500&offset=0'
        }
    }
    
    It 'Should work with pipeline input' {
        $job = [PSCustomObject]@{
            client_id    = 1
            device_id    = 2
            id           = 3
            objectschema = 'job'
        }
    
        $job | Get-BackupJobHistory
    
        Should -Invoke Invoke-AxcientAPI -ModuleName AxcientAPI -ParameterFilter {
            $Endpoint -eq 'client/1/device/2/job/3/history?&limit=1500&offset=0'
        }
    }

    It 'Should parse -StartTimeBegin to the appropriate Unix timestamp' {
        $job = [PSCustomObject]@{
            client_id    = 1
            device_id    = 2
            id           = 3
            objectschema = 'job'
        }
    
        $job | Get-BackupJobHistory -StartTimeBegin '2024-08-12'
        
        Should -Invoke Invoke-AxcientAPI -ModuleName AxcientAPI -ParameterFilter {
            $Endpoint -eq 'client/1/device/2/job/3/history?starttime_begin=1723435200&limit=1500&offset=0'
        }
    }

    Context 'Pagination' {
        BeforeAll {
            Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
                New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
                if ($Endpoint -eq 'client/1/device/2/job/3/history?&limit=1500&offset=0') {
                    0..1499 | % { [PSCustomObject]@{ id = $_ } }
                }
                elseif ($Endpoint -eq 'client/1/device/2/job/3/history?&limit=1500&offset=1500') {
                    1500..2999 | % { [PSCustomObject]@{ id = $_ } }
                }
                else {
                    2000..2424 | % { [PSCustomObject]@{ id = $_ } }
                }
            }
            $job = [PSCustomObject]@{
                client_id    = 1
                device_id    = 2
                id           = 3
                objectschema = 'job'
            }
        }
        It 'Retrieves all results' {
            $history = $job | Get-BackupJobHistory
            $history | Should -HaveCount 3425
            Should -ModuleName AxcientAPI -Invoke Invoke-AxcientAPI -Times 3
        }
        It 'Does not page more than needed if total results < 1500' {
            Mock -ModuleName AxcientAPI Invoke-AxcientAPI {
                0..22 | % { [PSCustomObject]@{ id = $_ } }
            }
            $history = $job | Get-BackupJobHistory
            $history | Should -HaveCount 23
            Should -ModuleName AxcientAPI -Invoke Invoke-AxcientAPI -Times 1
        }
        It 'Does not paginate on error' {
            Mock -ModuleName AxcientAPI Invoke-AxcientAPI { }
            $history = $job | Get-BackupJobHistory
            $history | Should -Be $null
            Should -ModuleName AxcientAPI -Invoke Invoke-AxcientAPI -Times 1
        }
    }
}
    