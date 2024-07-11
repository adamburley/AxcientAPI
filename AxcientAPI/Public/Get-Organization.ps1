<#
.SYNOPSIS
Retrieves information about the partner organization.

.DESCRIPTION
Retrieves basic information about the partner organization related to the authenticating
user API Key.

.EXAMPLE
Get-Organization

id_           : 26
name          : Spacely Sprockets
active        : True
brand_id      : SPACELY
salesforce_id : reseller_salesforce_id
#>

function Get-Organization {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param()
    Invoke-AxcientAPI -Endpoint 'organization' -Method Get | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'organization' -PassThru
}