<#
.SYNOPSIS
Get information about an Appliance.

.DESCRIPTION
Gets information about appliances. Can accept Appliance or Client objects from the pipeline or from parameters.
You can also specify an appliance by its service ID.

.PARAMETER Appliance
Appliance object or ID to retrieve information on.

.PARAMETER Client
Specifies the client object or reference to retrieve information for all appliances associated with a specific client.

.PARAMETER InputObject
Specifies the appliance or client object received through the pipeline to retrieve information.

.PARAMETER ServiceID
Specifies the service ID of the appliance. Must be a 4-character alphanumeric string.

.PARAMETER IncludeDevices
Indicates whether to include device information along with the appliance information. By default, it is set to $true.

.INPUTS
Appliance or Client object

.OUTPUTS
An Appliance object or array or Appliance objects

.EXAMPLE
Get-Appliance
# Returns all appliances avaialble to the user account at this organization

.EXAMPLE
Get-Appliance -Appliance 12345

.EXAMPLE
$client | Get-Appliance
#>
function Get-Appliance {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Appliance')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'appliance' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Appliance,

        [Parameter(ParameterSetName = 'Client')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Client,

        [Parameter(ValueFromPipeline, ParameterSetName = 'Pipeline', DontShow)]
        [ValidateScript({ $_.objectschema -iin 'appliance', 'client' }, ErrorMessage = 'Only Appliance and Client objects are accepted via the pipeline.' )]
        [object]$InputObject,

        [Parameter(ParameterSetName = 'All')]
        [Alias('service_id')]
        [ValidatePattern('^[a-zA-Z0-9]{4}$', ErrorMessage = 'Service ID must be a 4-character alphanumeric string')]
        [string]$ServiceID,

        [Parameter()]
        [Alias('include_devices')]
        [bool]$IncludeDevices = $true
    )
    process {
        $_queryParameters = @()
        switch ($PSCmdlet.ParameterSetName) {
            'Appliance' {
                $_applianceId = Find-ObjectIdByReference $Appliance
                $_endpoint = "appliance/$_applianceId"
            }
            'Client' {
                $_clientId = Find-ObjectIdByReference $Client
                $_endpoint = "client/$_clientId/appliance"
            }
            'Pipeline' {
                if ($InputObject.objectschema -eq 'appliance') {
                    $_applianceId = $InputObject.id
                    $_endpoint = "appliance/$_applianceId"
                }
                elseif ($InputObject.objectschema -eq 'client') {
                    $_clientId = $InputObject.id
                    $_endpoint = "client/$_clientId/appliance"
                }
            }
            default {
                $_endpoint = "appliance"
                if ($ServiceID) {
                    $_queryParameters += "service_id=$ServiceID"
                }
            }
        }
        if ($PSBoundParameters.ContainsKey('IncludeDevices')) {
            $_queryParameters += "include_devices=$IncludeDevices"
        }

        if ($_queryParameters) {
            $_endpoint += '?' + ($_queryParameters -join '&')
        }
        $_clientId = $Client.id ?? $Appliance.client_id ?? $InputObject.client_id # Catch client ID if the passed Appliance object contains it
        Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'appliance' -PassThru |
            Add-Member -MemberType NoteProperty -Name 'client_id' -Value $_clientId -PassThru
        }
    }
}