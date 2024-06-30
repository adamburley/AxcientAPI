function Get-Client {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Id_')]
        [int]$Id,
        
        [switch]$IncludeAppliances
    )
    $call = Invoke-AxcientAPI -Endpoint "client/$Id" -Method Get
    if ($call.error){
        $_errorMessage = $call.error.Message
        Write-Error -Message "Get-Client returned $_errorMessage"
        $call
    }
    else {
        $call | Foreach-Object { $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'client' -PassThru }
    }
}