function Invoke-AxcientAPI {
    [CmdletBinding()]
    param (
        [string]$Endpoint,
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get,

        [switch]$ReturnErrors
    )
    $_uri = "$Script:AxcientBaseUrl/$Endpoint"
    Write-Debug -Message "Axcient API: $Method $_uri"
    $response = Invoke-WebRequest -Uri $_uri -Method $Method  -Headers @{ 'X-API-Key' = $AxcientApiKey } -SkipHttpErrorCheck
    Write-Debug -Message "API Returned: $($response.StatusCode) $($response.StatusDescription) $($response.Content.Length) bytes of $($response.Headers.'Content-Type')"
    if ($response.StatusCode -ne 200) {
        $parsedContent = switch ($response.Headers.'Content-Type') {
            'application/problem+json' { [System.Text.Encoding]::UTF8.GetString($response.Content) | ConvertFrom-Json }
            'application/json' { $response.Content | ConvertFrom-Json }
            default { 
                Write-Debug "The API did not return an expected body. Body: $($response.Content)" 
                
                $httpCodeMessage = switch ($response.StatusCode) { # This is from the OpenAPI schema
                    400 { 'One or more specified IDs are invalid' }
                    401 { 'Access token is missing or invalid' }
                    404 { 'Resource not found or delegated to authenticating user' }
                    default { "$($response.StatusCode) $($response.StatusDescription)" }
                }

                [pscustomobject][ordered]@{
                    detail = $httpCodeMessage
                    status = $response.StatusCode
                    title = $response.StatusDescription
                    type = 'UndefiniedHTTPErrorResponse'
                }
            }
        }
        Write-Debug -Message "Failed to invoke Axcient API. StatusCode: $($response.StatusCode). Content: $($parsedContent | Convertto-json -Depth 5 -Compress)"


        Write-Error "API returned an error: $($parsedContent.detail)" -RecommendedAction 'Retry another time.'

        if ($ReturnErrors) { $parsedContent }
    }
    else {
        $response.Content | ConvertFrom-Json
    }
}