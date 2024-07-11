<#
.SYNOPSIS
Retrieves information on a client or clients

.DESCRIPTION
Retrieves information for for one or multiple clients, including client ID, name, health status,
and device counters. Optionally basic information about the client's appliances can be included.

.PARAMETER Client
Client or clients to retrieve information for. Accepts one or more integer client IDs or objects.
Parameter accepts from the pipeline.

.PARAMETER IncludeAppliances
Return basic information about appliances for this client.

.INPUTS
Accepts a Client object.

.OUTPUTS
Returns a Client object or array of Client objects.

.EXAMPLE
$clients = Get-Client
PS > $clients.Count
42

.EXAMPLE
$oneClientFreshData = Get-Client -Client $clients[0]
# Returns updated client information

.EXAMPLE
$oneClientFreshData = $clients[0] | Get-Client -IncludeAppliances
# Returns updated client information, now with basic appliance information

.EXAMPLE
$oneClient = Get-Client -Client 12345
PS > $oneClient.id_
12345
#>
function Get-Client {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([PSCustomObject], [PSCustomObject[]])]
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