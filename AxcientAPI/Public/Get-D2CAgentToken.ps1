<#
.SYNOPSIS
Gets a Direct-to-Cloud (D2C) agent token for a client and vault.

.DESCRIPTION
The Get-D2CAgentToken function retrieves a Direct-to-Cloud (D2C) agent token for a specified client and vault. This token is used for authenticating D2C agents with the Axcient cloud service.

.PARAMETER Client
Specifies the client for which to retrieve the D2C agent token. Can be a client ID (integer) or a client object with an 'id' property.

.PARAMETER Vault
Specifies the vault for which to retrieve the D2C agent token. Can be a vault ID (integer) or a vault object with an 'id' property.

.PARAMETER PassThru
If specified, adds the token_id as a property to the input Client object instead of returning a new object.

.EXAMPLE
Get-D2CAgentToken -Client 123 -Vault 456

This example retrieves a D2C agent token for client ID 123 and vault ID 456.

.EXAMPLE
$client | Get-D2CAgentToken -Vault 789

This example retrieves a D2C agent token for the client object in the pipeline and vault ID 789.

.EXAMPLE
Get-D2CAgentToken -Client $clientObj -Vault $vaultObj -PassThru

This example retrieves a D2C agent token for the specified client and vault objects, and adds the token_id to the client object.

.INPUTS
[System.Object]
You can pipe a client object to Get-D2CAgentToken.

.OUTPUTS
[PSCustomObject]
Returns a custom object with client_id, vault_id, token_id, and objectschema properties.

#>
function Get-D2CAgentToken {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(ValueFromPipeline, Mandatory)]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Client,

        [Parameter(Mandatory)]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'vault' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Vault,

        [Parameter()]
        [switch]$PassThru
    )
    begin {
        $vaultParamId = Find-ObjectIdByReference $Vault
    }
    process {
        foreach ($C in $Client) {
            $clientParamId = Find-ObjectIdByReference $C

            $result = Invoke-AxcientAPI -Endpoint "client/$clientParamId/vault/$vaultParamId/d2c_agent" -Method Post
            if ($result.token_id) {
                if ($PassThru -and $C -is [PSCustomObject] ) {
                    $Client | Add-Member -MemberType NoteProperty -Name 'd2c_token_id' -Value $result.token_id -Force -PassThru
                }
                else {
                    [PSCustomObject][Ordered]@{
                        client_id = $clientParamId
                        vault_id  = $vaultParamId
                        token_id  = $result.token_id
                        objectschema = 'd2c_agent_token'
                    }
                }
            }
        }
    }
}