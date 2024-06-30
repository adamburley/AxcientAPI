function Invoke-AxcientAPI {
    [CmdletBinding()]
    param (
        [string]$Endpoint,
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get
    )
    $_uri = "$Script:AxcientBaseUrl/$Endpoint"
    Write-Debug -Message "Axcient API: $Method $_uri"
    $response = Invoke-WebRequest -Uri $_uri -Method $Method  -Headers @{ 'X-API-HEADER' = $AxcientApiKey } -SkipHttpErrorCheck
    Write-Debug -Message "API Returned: $($response.StatusCode) $($response.StatusDescription) $($response.Content.Length) bytes"
    if ($response.StatusCode -ne 200) {
        Write-Debug -Message "Failed to invoke Axcient API. StatusCode: $($response.StatusCode). Content: $($response.Content)"
        # The mock server is not fully featured for error codes, so some of this is guesswork.
        $parsedContent = if ($response.Content | Test-Json -ErrorAction SilentlyContinue) {
            $response.Content | ConvertFrom-Json
        }
        else {
            $response.Content
        }

        $schemaError = switch ($response.StatusCode) { # This is from the OpenAPI schema
            400 { 'One or more specified IDs are invalid' }
            401 { 'Access token is missing or invalid' }
            404 { 'Resource not found or delegated to authenticating user' }
            default { "$($response.StatusCode) $($response.StatusDescription)" }
        }
        
        [pscustomobject]@{
            error = [pscustomobject][ordered]@{
                Message = $schemaError
                StatusCode = $response.StatusCode
                StatusDescription = $response.StatusDescription
                Content = $parsedContent
            }
        }
    }
    else {
        $response.Content | ConvertFrom-Json
    }
}