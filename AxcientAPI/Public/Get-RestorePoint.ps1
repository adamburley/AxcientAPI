function Get-RestorePoint {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id_')]
        [int]$DeviceId
    )
    process {
        Invoke-AxcientAPI -Endpoint "device/$DeviceId/autoverify" -Method Get   
    }
}