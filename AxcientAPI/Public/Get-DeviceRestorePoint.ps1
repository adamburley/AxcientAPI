<#
.SYNOPSIS
Retrieves restore points for a device.

.DESCRIPTION
For each specified device, returns an object with current status and a list of restore points.

.PARAMETER Device
One or more Device objects or integers to retrieve restore points for.

.INPUTS
Restore point object

.OUTPUTS
Restore point object or array of Restore point objects

.EXAMPLE
$devices = Get-Device
PS > $restorePoints = $devices | Get-DeviceRestorePoint
#>
function Get-DeviceRestorePoint {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Device
    )
    process {
        foreach ($thisDevice in $Device) {
            $_deviceId = Find-ObjectIdByReference $thisDevice
            Invoke-AxcientAPI -Endpoint "device/$_deviceId/restore_point" -Method Get | Foreach-Object {
                $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $thisDevice.client_id -PassThru |
                Add-Member -MemberType NoteProperty -Name 'device_id' -Value $thisDevice.id -PassThru |
                Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device.restorepoint' -PassThru
            }
        }
    }
}