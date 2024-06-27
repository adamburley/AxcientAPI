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
        Write-Error -Message "Failed to invoke Axcient API. StatusCode: $($response.StatusCode). Content: $($response.Content)"
        $parsedContent = if ($response.Content | Test-Json -ErrorAction SilentlyContinue) {
            $response.Content | ConvertFrom-Json
        }
        else {
            $response.Content
        }
        
        [pscustomobject]@{
            Response = $response.StatusCode
            Content = $parsedContent
        }
    }
    else {
        $response.Content | ConvertFrom-Json
    }
}