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