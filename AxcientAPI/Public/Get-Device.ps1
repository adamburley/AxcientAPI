function Get-Device {
    [CmdletBinding(DefaultParameterSetName = 'Client')]
    param (
        [Parameter(ValueFromPipeline, Mandatory, ParameterSetName = 'Client')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Client,

        [Parameter(Mandatory, ParameterSetName = 'Device')]
        [Alias('Id')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Device
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Device') {
            foreach ($thisDevice in $Device) {
                $_deviceId = Find-ObjectIdByReference $thisDevice
                $_endpoint = "device/$_deviceId"
                $call = Invoke-AxcientAPI -Endpoint $_endpoint -Method Get
                if ($call.error) {
                    $_errorMessage = $call.error.Message
                    Write-Error -Message "Get-Client returned $_errorMessage"
                    $call
                }
                else {
                    $call | Foreach-Object { $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $thisDevice.client_id -PassThru | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device' -PassThru }
                }
            }
        }
        else {
            foreach ($thisClient in $Client) {
                $_clientId = Find-ObjectIdByReference $thisClient
                $_endpoint = "client/$_clientId/device"
                $call = Invoke-AxcientAPI -Endpoint $_endpoint -Method Get
                if ($call.error) {
                    $_errorMessage = $call.error.Message
                    Write-Error -Message "Get-Client returned $_errorMessage"
                    $call
                }
                else {
                    $call | Foreach-Object { $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $_clientId -PassThru | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device' -PassThru }
                }
            }
        }
    }
}