function Get-Device {
    [CmdletBinding(DefaultParameterSetName = 'Client')]
    param (
        [Parameter(ValueFromPipelineByPropertyName, Mandatory, ParameterSetName = 'Client')]
        [Alias('Id_')]
        [int]$ClientId,
        
        [Parameter(Mandatory, ParameterSetName = 'Device')]
        [int]$DeviceId
    )
    $_endpoint = if ($PSCmdlet.ParameterSetName -eq 'Client') {
        "client/$ClientId/device"
    }
    else {
        "device/$DeviceId"
    }
    Invoke-AxcientAPI -Endpoint $_endpoint -Method Get
}