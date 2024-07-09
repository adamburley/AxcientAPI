function Get-Organization {
    [CmdletBinding()]
    param()
    $call = Invoke-AxcientAPI -Endpoint 'organization' -Method Get
    if ($call -isnot [array] -and $call.error) {
        $_errorMessage = $call.error.Message
        Write-Error -Message "call returned $_errorMessage"
        $call
    }
    else {
        $call | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'organization' -PassThru
    }
}