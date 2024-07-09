function Get-RestorePoint {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Device
    )
    process {
        foreach ($thisDevice in $Device) {
            $_deviceId = Find-ObjectIdByReference $thisDevice
            $call = Invoke-AxcientAPI -Endpoint "device/$_deviceId/restore_point" -Method Get
            if ($call -isnot [array] -and $call.error) {
                $_errorMessage = $call.error.Message
                Write-Error -Message "call returned $_errorMessage"
                $call
            }
            else {
                $call | Foreach-Object {
                    $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $thisDevice.client_id -PassThru |
                         Add-Member -MemberType NoteProperty -Name 'device_id' -Value $thisDevice.Id_ -PassThru |
                         Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device.restorepoint' -PassThru
                    }
            }
        }
    }
}