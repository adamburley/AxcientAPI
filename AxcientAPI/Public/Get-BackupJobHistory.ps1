<#
.SYNOPSIS
Get history of runs for a backup job.

.DESCRIPTION
Retrieves run history for a backup job

.PARAMETER Device
Device to retrieve information for. Accepts device ID or Device Object. If specifying a device
object, function will also use Client ID if available. Not required if present on Job object

.PARAMETER Client
Relevant Client ID or Object. Not required if Client ID is avilable on Device or Job object

.PARAMETER Job
A specific Job to retrieve information for.

.EXAMPLE
Get-BackupJobHistory -Device 12345 -Client 67890 -Job 54321

.EXAMPLE
$job | Get-BackupJobHistory

#>
function Get-BackupJobHistory {
    [CmdletBinding()]
    param (
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Device,

        [Parameter()]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Client,

        [Parameter(ValueFromPipeline, Mandatory)]
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
        Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $_clientId -Force -PassThru |
            Add-Member -MemberType NoteProperty -Name 'device_id' -Value $_deviceId -PassThru |
            Add-Member -MemberType NoteProperty -Name 'job_id' -Value $_jobId -PassThru |
            Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'job.history' -PassThru
        }
    }
}