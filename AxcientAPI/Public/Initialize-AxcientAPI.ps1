<#
.SYNOPSIS
Sets environment variables for calls to the Axcient API.

.PARAMETER ApiKey
The API key to authenticate the connection.

.PARAMETER MockServer
Specifies whether to use the mock server for testing purposes.

.EXAMPLE
Initialize-AxcientAPI -ApiKey "your-api-key"

#>
function Initialize-AxcientAPI {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter()]
        [switch]$MockServer
    )
    $baseUrl = $MockServer ? 'https://ax-pub-recover.wiremockapi.cloud' : 'https://axapi.developer.axcient.com/x360recover'
    $Script:AxcientBaseUrl = $baseUrl
    $Script:AxcientApiKey = $ApiKey
}