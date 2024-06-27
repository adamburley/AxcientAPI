function Get-Organization {
    [CmdletBinding()]
    param()
    Invoke-AxcientAPI -Endpoint 'organization'
}