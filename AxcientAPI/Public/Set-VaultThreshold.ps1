<#
.SYNOPSIS
Sets a threshold value for a vault.

.DESCRIPTION
The Get-VaultThreshold function sets the threshold value for a specified vault.
Currently the only threshold available is connectivity, in minutes. If additional thresholds
become available in the future they will be added via the -Type parameter.

By default returns a custom object for the threshold value. Provide a Vault object and specify
-PassThru and it will return a Vault object with the vault_thresholds property populated.

.PARAMETER Vault
Specifies the vault for which to set the threshold. This can be a vault ID (integer) or a vault object.

.PARAMETER Type
Specifies the type of threshold to set. Currently, only 'Connectivity' is supported.

.PARAMETER PassThru
When specified, and when a vault object is provided as input, the function will return the input object with the updated
threshold value added to it.

.EXAMPLE
Set-VaultThreshold -Vault 123 -ThresholdMinutes 120

    vault_id     : 123
    type         : Connectivity
    threshold    : 120
    objectschema : vault.threshold


.EXAMPLE
$vault = $vault | Get-VaultThreshold -ThresholdMinutes 120 -PassThru
PS > $vault | select id, vault_thresholds

id               : 1454132
vault_thresholds : @{connectivity_threshold=120}

This example updates the threshold and returns the new value within the vault object.

.INPUTS
[PSCustomObject]
Accepts a Vault object from the pipeline

.OUTPUTS
[PSCustomObject]
A vault.threshold object or a Vault object

.LINK
Get-VaultThreshold

#>
function Set-VaultThreshold {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'vault' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Vault,

        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$ThresholdMinutes,

        [Parameter()]
        [ValidateSet('Connectivity')]
        [string]$Type = 'Connectivity',

        [Parameter()]
        [switch]$PassThru

    )
    process {
        $vaultId = Find-ObjectIdByReference $Vault
        if ($PSCmdlet.ShouldProcess("Vault ID $vaultId","Update $Type threshold to $ThresholdMinutes minutes")) {
            $result = Invoke-AxcientAPI -Endpoint "vault/$vaultId/threshold/$($Type.ToLower())" -Method Post -Body @{ 'threshold' = $ThresholdMinutes }
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
}