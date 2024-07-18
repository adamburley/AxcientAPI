BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}

Describe 'Get-BackupJob' {
    BeforeAll {
        Mock -ModuleName AxcientAPI -CommandName Invoke-AxcientAPI {
            New-Variable -Name InvocationEndpoint -Value $Endpoint -Scope Script -Force
        }
        Mock -ModuleName AxcientAPI -CommandName Write-Error { }
        Mock Write-Warning { }
        Initialize-AxcientAPI -ApiKey 'pesterapikey' -MockServer
    }
    Context 'Parameter validation' {
        It 'Accepts explicit Client, Device, and Job parameters [int]' {
            { Get-BackupJob -Client 1 -Device 2 -Job 3 } | Should -Not -Throw
            $InvocationEndpoint | Should -Be 'client/1/device/2/job/3'
        }
        It 'Accepts a Job object with Client and Device properties' {
            $jobObject = [PSCustomObject]@{
                client_id = 1
                device_id = 2
                Id_ = 3
                objectschema = 'job'
            }
            { Get-BackupJob -Job $jobObject } | Should -Not -Throw
            $InvocationEndpoint | Should -Be 'client/1/device/2/job/3'
        }
        It 'Accepts a Job object without Client and Device properties' {
            $jobObject = [PSCustomObject]@{
                client_id = $null
                device_id = $null
                Id_ = 3
                objectschema = 'job'
            }
            { Get-BackupJob -Job $jobObject -Client 4 -Device 6 } | Should -Not -Throw
            $InvocationEndpoint | Should -Be 'client/4/device/6/job/3'
        }
        It 'Accepts a Device object with Client property' {
            $deviceObject = [PSCustomObject]@{
                client_id = 1
                Id_ = 2
                objectschema = 'device'
            }
            { Get-BackupJob -Device $deviceObject } | Should -Not -Throw
            $InvocationEndpoint | Should -Be 'client/1/device/2/job'
        }
        It 'Accepts a Device object without Client property' {
            $deviceObject = [PSCustomObject]@{
                client_id = $null
                Id_ = 2
                objectschema = 'device'
            }
            { Get-BackupJob -Device $deviceObject -Client 4 } | Should -Not -Throw
            $InvocationEndpoint | Should -Be 'client/4/device/2/job'
        }
        It 'Accepts a Client object' {
            $clientObject = [PSCustomObject]@{
                Id_ = 1
                objectschema = 'client'
            }
            { Get-BackupJob -Client $clientObject -Device 12 } | Should -Not -Throw
            $InvocationEndpoint | Should -Be 'client/1/device/12/job'
        }
        It 'Accepts a Job object from the pipeline' {
            $jobObject = [PSCustomObject]@{
                client_id = 1
                device_id = 2
                Id_ = 3
                objectschema = 'job'
            }
            $jobObject | Get-BackupJob
            $InvocationEndpoint | Should -Be 'client/1/device/2/job/3'
        }
        It 'Accepts a Job object from the pipeline without a client id' {
            $jobObject = [PSCustomObject]@{
                client_id = $null
                device_id = 2
                Id_ = 3
                objectschema = 'job'
            }
            $jobObject | Get-BackupJob -Client 4
            $InvocationEndpoint | Should -Be 'client/4/device/2/job/3'
        }
        It 'Accepts a Device object from the pipeline' {
            $deviceObject = [PSCustomObject]@{
                client_id = 1
                Id_ = 2
                objectschema = 'device'
            }
            $deviceObject | Get-BackupJob
            $InvocationEndpoint | Should -Be 'client/1/device/2/job'
        }
        It 'Accepts a Device object from the pipeline without a client id' {
            $deviceObject = [PSCustomObject]@{
                client_id = $null
                Id_ = 2
                objectschema = 'device'
            }
            $deviceObject | Get-BackupJob -Client 4
            $InvocationEndpoint | Should -Be 'client/4/device/2/job'
        }
        It 'Ignores a Device parameter if present in a Job object' {
            $jobObject = [PSCustomObject]@{
                client_id = 1
                device_id = 2
                Id_ = 3
                objectschema = 'job'
            }
            { Get-BackupJob -Job $jobObject -Device 4 } | Should -Not -Throw
            $InvocationEndpoint | Should -Be 'client/1/device/2/job/3'
        }
        It 'Ignores a Client or Device parameter if present in a Job object' {
            $jobObject = [PSCustomObject]@{
                client_id = 1
                device_id = 2
                Id_ = 3
                objectschema = 'job'
            }
            { Get-BackupJob -Job $jobObject -Client 4 -Device 12 } | Should -Not -Throw
            $InvocationEndpoint | Should -Be 'client/1/device/2/job/3'
        }
        It "Requires at least a client and device ID" {
            Get-BackupJob -Job 3
            InModuleScope AxcientAPI { Should -Invoke Write-Error -ParameterFilter { $Message -eq 'Missing client ID or device ID on job object. Specify with -Client and -Device parameters.' } }
        }
    }
}