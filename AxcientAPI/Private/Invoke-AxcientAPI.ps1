function Invoke-AxcientAPI {
    [CmdletBinding()]
    param (
        [string]$Endpoint,
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get,
        [object]$Body
    )
    if (-not $Script:AxcientBaseUrl) {
        Write-Error -Message "Axcient API is not initialized. Please execute Initialize-AxcientAPI to configure for prod or mock environments." -ErrorAction Stop
    }
    $ReturnErrors = $Script:AxcientReturnErrors
    $_uri = "$Script:AxcientBaseUrl/$Endpoint"
    Write-Debug -Message "Axcient API: $Method $_uri"
    $splat = @{
        Uri = $_uri
        Method = $Method
        Headers = @{ 'X-API-Key' = $AxcientApiKey; 'Accept' = 'application/json' }
        SkipHttpErrorCheck = $true
    }
    if ($Body) {
        $splat.Body = $Body | ConvertTo-Json
        $splat.Headers.'Content-Type' = 'application/json'
    }
    $response = Invoke-WebRequest @splat
    Write-Debug -Message "API Returned: $($response.StatusCode) $($response.StatusDescription) $($response.Content.Length) bytes of $($response.Headers.'Content-Type')"
    if ($response.StatusCode -ne 200) {
        # Attempt to parse the body
        $parsedContent = switch ($response.Headers.'Content-Type') {
            'application/problem+json' { [System.Text.Encoding]::UTF8.GetString($response.Content) | ConvertFrom-Json }
            'application/json' { $response.Content | ConvertFrom-Json }
            default {
                if ($response.Content | Test-Json -ErrorAction SilentlyContinue) { $response.Content | ConvertFrom-Json } # some responses arrive as JSON but with a text/html content type
                else {
                Write-Debug "The API did not return an expected body. Body: $($response.Content)"
                $null
                }
            }
        }
        # Bad API Key
        if ($response.StatusCode -eq 401 -and $parsedContent.PSObject.Properties.Count -eq 1 -and $parsedContent.message -eq 'Unauthorized') {
            $_keyLength = $AxcientApiKey.Length
            $_keySample = $_keyLength -gt 5 ? "[$($AxcientAPIKey.Substring(0,5))...] Verify key is active and the user account that generated the API key is active." : "Key is too short. Verify input to Initialize-AxcientAPI and retry."
            $_errorMessage = "API returned 401 Unauthorized. It's likely a problem with your API Key. Key: $_keySample"
        }
        # Bad endpoint
        elseif ($response.StatusCode -eq 401 -and $parsedContent.code -eq 401 -and $parsedContent.msg -eq 'Unauthorized' ) {
            $_errorMessage = "API returned 401 Unauthorized. There may be an issue with the specified endpoint or requested object. Endpoint: $Endpoint"
        }
        # Returned a full error object
        elseif ($parsedContent.detail -and $parsedContent.title) {
            $_errorMessage = "API returned {0} {1}: {2}" -f $response.StatusCode, $parsedContent.title, $parsedContent.detail
        }
        # Unknown response
        else {
                $httpCodeMessage = switch ($response.StatusCode) { # This is from the OpenAPI schema
                    400 { 'One or more specified IDs are invalid' }
                    401 { 'Access token is missing or invalid' }
                    404 { 'Resource not found or delegated to authenticating user' }
                    default { "$($response.StatusCode) $($response.StatusDescription)" }
                }

                $parsedContent = [pscustomobject][ordered]@{
                    detail = $httpCodeMessage
                    status = $response.StatusCode
                    title = $response.StatusDescription
                    type = 'UndefiniedHTTPErrorResponse'
                }
                $_errorMessage = "API returned an unexpected result: {0} {1}. Possible reason per API documentation is: {2}" -f $response.StatusCode, $response.StatusDescription, $httpCodeMessage
        }

        Write-Error $_errorMessage
        Write-Debug -Message "Failed to invoke Axcient API. StatusCode: $($response.StatusCode). Content: $($parsedContent | Convertto-json -Depth 5 -Compress)"

        if ($ReturnErrors) { $parsedContent }
    }
    else {
        $response.Content | ConvertFrom-Json
    }
}