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
        $call = Invoke-AxcientAPI -Endpoint $_endpoint -Method Get
        if ($call.error) {
            $_errorMessage = $call.error.Message
            Write-Error -Message "Get-Vault returned $_errorMessage"
            $call
        }
        else {
            $call | Foreach-Object { $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'vault' -PassThru }
        }
    }
}