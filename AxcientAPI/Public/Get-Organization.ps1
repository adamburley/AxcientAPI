function Get-Organization {
    [CmdletBinding()]
    param()
    Invoke-AxcientAPI -Endpoint 'organization' -Method Get | Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'organization' -PassThru
}