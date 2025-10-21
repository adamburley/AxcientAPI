function Get-BillingUsage {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('Actual','Billable')]
        [string]$Type = 'Actual'
    )
    process {
        Invoke-AxcientAPI -Endpoint "usage/$($Type.ToLower())" -Api billing
    }
}