function Find-ObjectIdByReference {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, Mandatory)]
        [AllowNull()]
        [object]$Reference,

        [Parameter()]
        [string]$Schema,

        [Parameter()]
        [switch]$Validation # Added because 0 is falsy but a valid id
    )
    process {
        Write-Debug "Find-ObjectIdByReference: $Reference"
        switch ($Reference) {
            { $null -eq $_ } { $null }
            { $Schema -and $_.objectschema } {
                if ($_.objectschema -ieq $Schema) {
                    $Validation ? $true : $_.Id_
                }
                else {
                    Write-Warning "Find-ObjectIdByReference: Schema mismatch: Expected '$Schema' but got '$($_.objectschema)'"
                    $null
                }
            }
            { $_.objectschema -and -not $Schema } { $Validation ? $true : $_.Id_ }
            { $_ -is [int64] -or $_ -is [int] } { $Validation ? $true : $_ }
            { $_ -is [string] } {
                $_result = -1
                if ([int]::TryParse($_, [ref]$_result)) {
                    $Validation ? $true : $_result
                }
                else {
                    Write-Warning "Find-ObjectIdByReference: Unable to parse string to Int: $_"
                    $null
                }
            }
            default {
                Write-Warning "Find-ObjectIdByReference: Could not parse object reference: $_"
                $null
            }
        }
    }
}