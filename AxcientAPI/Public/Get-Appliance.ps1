function Get-Appliance {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Appliance')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'appliance' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Appliance,

        [Parameter(ParameterSetName = 'Client')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Client,

        [Parameter(ValueFromPipeline, ParameterSetName = 'Pipeline')]
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
                    $_applianceId = $InputObject.Id_
                    $_endpoint = "appliance/$_applianceId"
                }
                elseif ($InputObject.objectschema -eq 'client') {
                    $_clientId = $InputObject.Id_
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
        $_clientId = $Client.Id_ ?? $Appliance.client_id ?? $InputObject.client_id # Catch client ID if the passed Appliance object contains it
        Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'appliance' -PassThru |
            Add-Member -MemberType NoteProperty -Name 'client_id' -Value $_clientId -PassThru
        }
    }
}