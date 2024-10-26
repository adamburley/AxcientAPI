<#
.SYNOPSIS
Retrieves a threshold value for a vault.

.DESCRIPTION
The Get-VaultThreshold function retrieves the threshold value for a specified vault.
Currently the only threshold available is connectivity, in minutes. If additional thresholds
become available in the future they will be added via the -Type parameter.

By default returns a custom object for the threshold value. Provide a Vault object and specify
-PassThru and it will return a Vault object with the vault_thresholds property populated.

.PARAMETER Vault
Specifies the vault for which to retrieve the threshold. This can be a vault ID (integer) or a vault object.

.PARAMETER Type
Specifies the type of threshold to retrieve. Currently, only 'Connectivity' is supported.

.PARAMETER PassThru
When specified, and when a vault object is provided as input, the function will return the input object with the threshold value added to it.

.EXAMPLE
Get-VaultThreshold -Vault 123

    vault_id     : 123
    type         : Connectivity
    threshold    : 240
    objectschema : vault.threshold


.EXAMPLE
$vault = $vault | Get-VaultThreshold -PassThru
PS > $vault | select id, vault_thresholds

id               : 14536
vault_thresholds : @{connectivity_threshold=240}

This example retrieves the threshold for the vault object in $vault and adds the threshold value to the vault object.

.INPUTS
[PSCustomObject]
Accepts a Vault object from the pipeline

.OUTPUTS
[PSCustomObject]
A vault.threshold object or a Vault object

#>
function Get-VaultThreshold {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'vault' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Vault,

        [Parameter()]
        [ValidateSet('Connectivity')]
        [string]$Type = 'Connectivity',

        [Parameter()]
        [switch]$PassThru
    )
    process {
        $vaultId = Find-ObjectIdByReference $Vault

        $result = Invoke-AxcientAPI -Endpoint "vault/$vaultId/threshold/$($Type.ToLower())"
        if ($Vault -is [PSCustomObject] -and $PassThru) {
            $newVault = $Vault.PSObject.Copy()
            if ($null -eq $newVault.vault_thresholds) {
                $newVault.vault_thresholds = [PSCustomObject]@{
                    connectivity_threshold = $result.threshold
                }
            }
            else {
                $newVault.vault_thresholds | Add-Member -MemberType NoteProperty -Name connectivity_threshold -Value $result.threshold
            }
            $newVault
        }
        else {
            [PSCustomObject]@{
                vault_id     = $vaultId
                type         = 'Connectivity'
                threshold    = $result.threshold
                objectschema = 'vault.threshold'
            }
        }
    }
}
