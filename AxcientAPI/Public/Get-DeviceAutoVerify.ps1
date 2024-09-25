<#
.SYNOPSIS
Retrieves auto-verify information for one or more devices.

.DESCRIPTION
Returns information about auto-verify tests. Each device returns an auto-verify object with one or
more runs detailed.

.PARAMETER Device
The device or devices to retrieve auto-verify information. Accepts integer IDs or Device objects.
Accepts from the pipeline.

.INPUTS
Device objects

.OUTPUTS
An Autoverify object or array of Autoverify objects.

.EXAMPLE
Get-DeviceAutoVerify -Device $device1, $device2
Retrieves auto-verify information for $device1 and $device2.

.EXAMPLE
$clientDevices | Get-DeviceAutoVerify
Returns auto-verify information for all devices.
#>
function Get-DeviceAutoVerify {
    [CmdletBinding()]
    [OutputType([PSCustomObject], [PSCustomObject[]])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Device
    )
    process {
        foreach ($thisDevice in $Device) {
            $_deviceId = Find-ObjectIdByReference $thisDevice
            Invoke-AxcientAPI -Endpoint "device/$_deviceId/autoverify" -Method Get | Foreach-Object {
                $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $thisDevice.client_id -Force -PassThru |
                Add-Member -MemberType NoteProperty -Name 'device_id' -Value $thisDevice.id -PassThru |
                Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device.autoverify' -PassThru
            }
        }
    }
}