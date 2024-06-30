function Find-ObjectIdByReference {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, Mandatory)]
        [AllowNull()][AllowEmptyString()]
        [object]$Reference,

        [Parameter()]
        [string]$Schema,

        [Parameter()]
        [switch]$Validation # Added because 0 is falsy but a valid id
    )
    process {
        Write-Debug "Find-ObjectIdByReference: $Reference"
        switch ($Reference) {
            { $_ -iin $null,[string]::Empty } { $null }
            { if ($Schema) { $_.objectschema -eq $Schema } else { $_.objectschema } } { $Validation ? $true : $_.Id_ }
            { $_ -is [int64] -or $_ -is [int] } { $Validation ? $true : $_ }
            { $_ -is [string] } {
                $_result = -1
                if ([int]::TryParse($_, [ref]$_result)) {
                    $Validation ? $true : $_result
                } else { 
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