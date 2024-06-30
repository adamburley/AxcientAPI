function Get-BackupJobHistory {
    [CmdletBinding(DefaultParameterSetName = 'Device')]
    param (
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Device,

        [Parameter()]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Client,

        [Parameter(ValueFromPipeline,Mandatory)]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'job' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Job
    )
    begin {
        $deviceParamID = Find-ObjectIdByReference $Device
        $clientParamID = Find-ObjectIdByReference $Client
    }
    process {
        $_jobId = Find-ObjectIdByReference $Job
        $_clientId = $Job.client_id ?? $clientParamID
        $_deviceId = $Job.device_id ?? $deviceParamID
        Write-Debug "Get-BackupJobHistory: Client: $_clientId, Device: $_deviceId, Job: $_jobId"
        if ($null -eq $_jobId -or $null -eq $_clientId -or $null -eq $_deviceId) {
            Write-Error "Missing client ID, device ID, or job ID. All three are required and may be included in the Job object or specified as parameters."
            continue
        }
        $_endpoint = "client/$_clientId/device/$_deviceId/job/$_jobId/history"
        $call = Invoke-AxcientAPI -Endpoint $_endpoint -Method Get
        if ($call.error) {
            $_errorMessage = $call.error.Message
            Write-Error -Message "Get-Client returned $_errorMessage"
            $call
        }
        else {
            $call | Foreach-Object {
                $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $_clientId -PassThru |
                Add-Member -MemberType NoteProperty -Name 'device_id' -Value $_deviceId -PassThru |
                Add-Member -MemberType NoteProperty -Name 'job_id' -Value $_jobId -PassThru |
                Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'job.history' -PassThru
            }
        }

    }
}