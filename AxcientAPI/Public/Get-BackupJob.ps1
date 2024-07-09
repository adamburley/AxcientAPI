function Get-BackupJob {
    [CmdletBinding()]
    param (
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Device,

        [Parameter()]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Client,

        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'job' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Job,

        [Parameter(ValueFromPipeline)]
        [ValidateScript({ $_.objectschema -iin 'device', 'job' }, ErrorMessage = 'Only Device or Job objects are accepted via the pipeline.' )]
        [object]$InputObject
    )
    begin {
        $deviceParamID = Find-ObjectIdByReference $Device
        $clientParamID = Find-ObjectIdByReference $Client
    }
    process {
        if ($InputObject.objectschema -eq 'job' -xor $PSBoundParameters.ContainsKey('Job')) {
            $_jobId = $InputObject.Id_
            $_clientId = $InputObject.client_id ?? $clientParamID
            $_deviceId = $InputObject.device_id ?? $deviceParamID
            Write-Debug "Get-BackupJob: Per-Job flow: Client: $_clientId, Device: $_deviceId, Job: $_jobId"
            $_endpoint = "client/$_clientId/device/$_deviceId/job/$_jobId"
            if (-not ($_clientId -and $_deviceId)) {
                Write-Error "Missing client ID or device ID on job object. Specify with -Client and -Device parameters."
                continue
            }
        }
        elseif ($InputObject.objectschema -eq 'device' -xor $PSBoundParameters.ContainsKey('Device')) {
            $_clientId = $InputObject.client_id ?? $clientParamID
            $_deviceId = $InputObject.Id_ ?? $deviceParamID
            Write-Debug "Get-BackupJob: Device flow: Client: $_clientId, Device: $_deviceId, Job: $_jobId"
            $_endpoint = "client/$_clientId/device/$_deviceId/job"
            if (-not $_clientId) {
                Write-Error "Missing client ID on device object. Specify with -Client parameter."
                continue
            }
        }
        else {
            if ($InputObject.objectschema -eq 'Device' -and $PSBoundParameters.ContainsKey('Device')) {
                Write-Error 'Device specified via pipeline and -Device parameter. Use one or the other.'
            } elseif ($InputObject.objectschema -eq 'Job' -and $PSBoundParameters.ContainsKey('Job')) {
                Write-Error 'Job specified via pipeline and -Job parameter. Use one or the other.'
            } else {
                Write-Error "At least Device and Client ID must be specified as an object member or via parameters."
            }
            continue
        }
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
                Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'job' -PassThru
            }
        }

    }
}