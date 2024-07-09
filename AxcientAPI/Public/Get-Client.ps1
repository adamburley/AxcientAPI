function Get-Client {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ValueFromPipeline, ParameterSetName = 'Client')]
        [Alias('Id')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Client,

        [Parameter()]
        [switch]$IncludeAppliances
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Client') {
            foreach ($thisClient in $Client) {
                $_endpoint = "client/$Id"
                if ($IncludeAppliances) {
                    $_endpoint += '?include_appliances=true'
                }
                $call = Invoke-AxcientAPI -Endpoint $_endpoint -Method Get
                if ($call.error) {
                    $_errorMessage = $call.error.Message
                    Write-Error -Message "Get-Client returned $_errorMessage"
                    $call
                }
                else {
                    $call | Foreach-Object { $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'client' -PassThru }
                }
            }
        }
        else {
            $_endpoint = "client"
            if ($IncludeAppliances) {
                $_endpoint += '?include_appliances=true'
            }
            $call = Invoke-AxcientAPI -Endpoint $_endpoint -Method Get
            if ($call.error) {
                $_errorMessage = $call.error.Message
                Write-Error -Message "Get-Client returned $_errorMessage"
                $call
            }
            else {
                $call | Foreach-Object { $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'client' -PassThru }
            }
        }
    }
}