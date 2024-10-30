<#
.SYNOPSIS
Retrieves information about devices.

.DESCRIPTION
Retrieves information about protected devices, including agent status, version, IP Address,
host OS, and more. You can specify by Client or Device. If no parameters are provided, the
function returns all devices available under the authenticated account.

.PARAMETER Client
Client to retrieve a list of devices for. Accepts one or more integer client IDs or objects.
You may pipe Client objects to this function.

.PARAMETER Device
A specific device or devices to retrieve information for. Accepts one or more integer device
IDs or objects.

.PARAMETER ServiceId
The four-character service id for the desired device. Only available when specifying a client

.PARAMETER D2COnly
Return D2C devices only. Available when specifying a client
Note: This parameter is ignored if ServiceId is specified

.INPUTS
Client objects

.OUTPUTS
A Device object or array of Device objects

.EXAMPLE
Get-Device
# Returns a list of all devices available under the authenticated account.
# Note: This parameter set paginates calls in offsets of 100 to retrieve all devices.

.EXAMPLE
$client | Get-Device
# Returns a list of devices for the given client

.EXAMPLE
Get-Device -Client $client,$client2
# Returns a list of devices for two clients

.EXAMPLE
Get-Device -Device 12345

.EXAMPLE
Get-Device -Device $myDevice
#>
function Get-Device {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([PSCustomObject], [PSCustomObject[]])]
    param (
        [Parameter(ValueFromPipeline, ParameterSetName = 'Client')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Client,

        [Parameter(ParameterSetName = 'Device')]
        [Alias('Id')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Device,

        [Parameter(ParameterSetName = 'Client')]
        [Alias('service_id')]
        [ValidateLength(4,4)]
        [string]$ServiceId,

        [Parameter(ParameterSetName = 'Client')]
        [Alias('d2c_only')]
        [switch]$D2COnly
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Device') {
            foreach ($thisDevice in $Device) {
                $_deviceId = Find-ObjectIdByReference $thisDevice
                $_endpoint = "device/$_deviceId"
                Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object {
                    $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device' -PassThru
                }
            }
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'Client') {
            foreach ($thisClient in $Client) {
                $_clientId = Find-ObjectIdByReference $thisClient
                $_endpoint = "client/$_clientId/device"
                If ($ServiceId -and $D2COnly) {
                    Write-Warning -Message 'Only one of service_id and d2c_only may be specified. Ignoring d2c_only switch.'
                }
                if ($ServiceId) { $_endpoint += "?service_id=$ServiceId"}
                elseif ($D2COnly) { $_endpoint += "?d2c_only=true" }
                Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object {
                    $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device' -PassThru
                }
            }
        }
        else {
            $offset = 0
            do {
                Write-Debug "Pagination Offset: $offset"
                $thisPage = Invoke-AxcientAPI -Endpoint "device?limit=100&offset=$offset" -Method Get | Foreach-Object {
                    $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device' -PassThru
                }
                $offset += $thisPage.Count
                $thisPage
            } while ($thisPage.Count -eq 100)
        }
    }
}