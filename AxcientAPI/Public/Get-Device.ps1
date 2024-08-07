﻿<#
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

.INPUTS
Client objects

.OUTPUTS
A Device object or array of Device objects

.EXAMPLE
Get-Device
# Returns a list of all devices available under the authenticated account.

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
    [CmdletBinding(DefaultParameterSetName = 'None')]
    [OutputType([PSCustomObject], [PSCustomObject[]])]
    param (
        [Parameter(ValueFromPipeline, ParameterSetName = 'Client')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Client,

        [Parameter(ParameterSetName = 'Device')]
        [Alias('Id')]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object[]]$Device
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
                Invoke-AxcientAPI -Endpoint $_endpoint -Method Get | Foreach-Object {
                    $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device' -PassThru
                }
            }
        }
        else {
            Invoke-AxcientAPI -Endpoint 'device' -Method Get | Foreach-Object {
                $_ | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'device' -PassThru
            }
        }
    }
}