<#
.SYNOPSIS
Get information about vaults

.DESCRIPTION
Get information about a vaults related to an organization or on a specific vault. If requesting
information for all vaults you can filter by type, state, and URL presence.

.PARAMETER Vault
Vault object or ID to retrieve information on.

.PARAMETER Type
Specifies the type of vaults to retrieve. Valid values are 'Private' and 'Cloud'. Returns both
types if not specified.

.PARAMETER Active
Specifies whether to retrieve active vaults only. If set to $true, only active vaults will be
retrieved. If set to $false, only inactive vaults will be retrieved. If not set, the result
is not filtered by active state.

.PARAMETER WithUrl
Filter on presence of URL. If true, only vaults with a URL will be retrieved. If false, only vaults
without a URL will be retrieved. If not set, the result is not filtered by URL presence.

.PARAMETER Limit
Specifies the maximum number of vaults to retrieve.

.PARAMETER IncludeDevices
Specifies whether to include devices associated with the vaults in the retrieved information. If set to $true, devices will be included.

.EXAMPLE
Get-Vault -Vault 12345

.EXAMPLE
Get-Vault -Type 'Private' -Active $true -WithUrl $true -IncludeDevices $false

.INPUTS
    Pipeline input is not accepted.

.OUTPUTS
Returns a Vault object or array of Vault objects
    [PSCustomObject],[PScustomObject[]]
#>
function Get-Vault {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(ValueFromPipeline, ParameterSetName = 'Vault')]
        [Alias('Id')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'vault' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Vault,

        [Parameter(ParameterSetName = 'All')]
        [Alias('vault_type')]
        [ValidateSet('Private', 'Cloud')]
        [string]$Type,

        [Parameter(ParameterSetName = 'All')]
        [bool]$Active,

        [Parameter(ParameterSetName = 'All')]
        [Alias('with_url')]
        [bool]$WithUrl,

        [Parameter(ParameterSetName = 'All')]
        [int]$Limit,

        [Parameter(ParameterSetName = 'All')]
        [Alias('include_devices')]
        [bool]$IncludeDevices = $true
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Vault') {
            $_vaultId = Find-ObjectIdByReference $Vault
            $_endpoint = "vault/$_vaultId"
        }
        else {
            $_queryParameters = @()
            if ($Type) {
                $_queryParameters += "type=$Type"
            }
            if ($PSBoundParameters.ContainsKey('Active')) {
                $_queryParameters += "active=$Active"
            }
            if ($PSBoundParameters.ContainsKey('WithUrl')) {
                $_queryParameters += "with_url=$WithUrl"
            }
            if ($Limit) {
                $_queryParameters += "limit=$Limit"
            }
            if ($PSBoundParameters.ContainsKey('IncludeDevices')) {
                $_queryParameters += "include_devices=$IncludeDevices"
            }
            if ($_queryParameters) {
                $_endpoint = "vault?" + ($_queryParameters -join '&')
            }
            else {
                $_endpoint = "vault"
            }
        }
        Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object { $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'vault' -PassThru }
    }
}