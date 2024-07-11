<#
.SYNOPSIS
Get backup job information for a device.

.DESCRIPTION
Retrieves the Job configuration for a device. May return more than one Job.

.PARAMETER Device
Device to retrieve information for. Accepts device ID or Device Object. If specifying a device
object, function will also use Client ID if available. Not required if present on Job object

.PARAMETER Client
Relevant Client ID or Object. Not required if Client ID is avilable on Device or Job object

.PARAMETER Job
A specific Job to retrieve information for.

.INPUTS
Accepts Device or Job objects. If Client ID or Device ID is not present on passed object it must
be specified as a separate parameter.

.OUTPUTS
A Job object or array of Job objects

.EXAMPLE
Get-BackupJob -Device 12345 -Client 67890 -Job 54321

.EXAMPLE
# Get all Jobs for all devices for a client.
PS > Get-Client -Client 49282 | Get-Device | Get-BackupJob
#>
function Get-BackupJob {
    [CmdletBinding()]
    [OutputType([PSCustomObject],[PScustomObject[]])]
    param (
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Device,

        [Parameter()]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Client,

        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'job' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Job,

        [Parameter(ValueFromPipeline, DontShow)]
        [ValidateScript({ $_.objectschema -iin 'device', 'job' }, ErrorMessage = 'Only Device or Job objects are accepted via the pipeline.' )]
        [object]$InputObject
    )
    begin {
        $deviceParamID = Find-ObjectIdByReference $Device
        $clientParamID = Find-ObjectIdByReference $Client
    }
    process {
        if ($InputObject.objectschema -eq 'job' -xor $PSBoundParameters.ContainsKey('Job')) {
            $_io = $InputObject ?? $Job
            $_jobId = $_io.Id_
            $_clientId = $_io.client_id ?? $clientParamID
            $_deviceId = $_io.device_id ?? $deviceParamID
            Write-Debug "Get-BackupJob: Per-Job flow: Client: $_clientId, Device: $_deviceId, Job: $_jobId"
            $_endpoint = "client/$_clientId/device/$_deviceId/job/$_jobId"
            if (-not ($_clientId -and $_deviceId)) {
                Write-Error "Missing client ID or device ID on job object. Specify with -Client and -Device parameters."
                continue
            }
        }
        elseif ($InputObject.objectschema -eq 'device' -xor $PSBoundParameters.ContainsKey('Device')) {
            $_io = $InputObject ?? $Device
            $_clientId = $_io.client_id ?? $clientParamID
            $_deviceId = $_io.Id_ ?? $deviceParamID
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
            }
            elseif ($InputObject.objectschema -eq 'Job' -and $PSBoundParameters.ContainsKey('Job')) {
                Write-Error 'Job specified via pipeline and -Job parameter. Use one or the other.'
            }
            else {
                Write-Error "At least Device and Client ID must be specified as an object member or via parameters."
            }
            continue
        }
        Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $_clientId -PassThru |
            Add-Member -MemberType NoteProperty -Name 'device_id' -Value $_deviceId -PassThru |
            Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'job' -PassThru
        }
    }
}