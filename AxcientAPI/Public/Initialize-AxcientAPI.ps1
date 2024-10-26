<#
.SYNOPSIS
Sets API key, server URL, and error handling for AxcientAPI module functions.

.DESCRIPTION
Initialize-AxcientAPI sets the API key and server URL for AxcientAPI module functions. The API key is
required for both production and mock environments. By default the production server URL is utilized.
Use the -MockServer switch to specify the mock environment.

.PARAMETER ApiKey
API key to authenticate the connection.

.PARAMETER MockServer
Specifies whether to use the mock server for testing purposes.

.PARAMETER ReturnErrors
When set, module functions will return the error object if an API call fails. By default nothing is returned
on failure.

.EXAMPLE
Initialize-AxcientAPI -ApiKey "imalumberjackandimokay" -MockServer -ReturnErrors

.NOTES
 As of module version 0.3.0 and the July 2024 API release the error schema is not well-defined. The module
 attempts to return a consistent object of its own design.
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
    $baseUrl = $MockServer ? 'https://ax-pub-recover.wiremockapi.cloud/x360recover' : 'https://axapi.axcient.com/x360recover'
    $Script:AxcientBaseUrl = $baseUrl
    $Script:AxcientApiKey = $ApiKey
    if ($ReturnErrors) { $Script:AxcientReturnErrors = $true } else { $Script:AxcientReturnErrors = $false }
}