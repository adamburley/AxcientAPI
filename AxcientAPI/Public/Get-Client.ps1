function Get-Client {
    [CmdletBinding()]
    param (
        [int]$ClientId,
        [switch]$IncludeAppliances
    )
    Invoke-AxcientAPI -Endpoint "client/$ClientId" -Method Get
}