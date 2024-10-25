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
            $Endpoint -eq 'client/1/device/2/job/3/history' -and
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
            $Endpoint -eq 'client/2/device/1/job/3/history'
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
            $Endpoint -eq 'client/1/device/2/job/3/history'
        }
    }

}
    