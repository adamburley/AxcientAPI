<#
.SYNOPSIS
Prepares for calls to the Axcient API.

.PARAMETER ApiKey
The API key to authenticate the connection.

.PARAMETER MockServer
Specifies whether to use the mock server for testing purposes.

.PARAMETER ReturnErrors
When set, module functions will return the error object if an API call fails. By default nothing is returned on failure.

.EXAMPLE
Initialize-AxcientAPI -ApiKey "imalumberjackandimokay" -MockServer -ReturnErrors
#>
function Initialize-AxcientAPI {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter()]
        [switch]$MockServer,

        [Parameter()]
        [switch]$ReturnErrors
    )
    $baseUrl = $MockServer ? 'https://ax-pub-recover.wiremockapi.cloud' : 'https://axapi.developer.axcient.com/x360recover'
    $Script:AxcientBaseUrl = $baseUrl
    $Script:AxcientApiKey = $ApiKey
    if ($ReturnErrors) { $Script:AxcientReturnErrors = $true } else { $Script:AxcientReturnErrors = $false }
}