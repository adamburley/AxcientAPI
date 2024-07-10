function Get-AutoVerify {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Device
    )
    process {
        foreach ($thisDevice in $Device) {
            $_deviceId = Find-ObjectIdByReference $thisDevice
            Invoke-AxcientAPI -Endpoint "device/$_deviceId/autoverify" -Method Get | Foreach-Object {
                $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $thisDevice.client_id -PassThru |
                Add-Member -MemberType NoteProperty -Name 'device_id' -Value $thisDevice.Id_ -PassThru |
                Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device.autoverify' -PassThru
            }
        }
    }
}