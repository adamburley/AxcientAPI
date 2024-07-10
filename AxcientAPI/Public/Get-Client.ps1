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
                $_id = Find-ObjectIdByReference $thisClient
                $_endpoint = "client/$_id"
                if ($IncludeAppliances) {
                    $_endpoint += '?include_appliances=true'
                }
                Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object { $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'client' -PassThru }
            }
        }
        else {
            $_endpoint = "client"
            if ($IncludeAppliances) {
                $_endpoint += '?include_appliances=true'
            }
            Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object { $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'client' -PassThru }
        }
    }
}