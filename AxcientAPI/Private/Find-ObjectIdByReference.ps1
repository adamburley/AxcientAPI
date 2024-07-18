<#
.SYNOPSIS
Validates an object and returns an ID

.DESCRIPTION
This function handles two needs: Validating a given object is likely valid, and returning a logical ID for the object.
It is used by functions that accept custom object input as a simple and consistent method to handle these needs.

.PARAMETER Reference
The reference to be evaluated. Valid inputs are integers, strings, objects containing an id property
and possibly an objectschema property, and $null. All other inputs raise a warning to the console and
return $null.

.PARAMETER Schema
The schema name to compare against the provided Reference object. If the object has an objectschema property
the function will return the object ID if the schema matches the provided schema. If the schema does not match
the function will return $null and write a warning to the console. [int] and [string] values are not evaluated
and process as if the parameter is not specified.

.PARAMETER Validation
If set, the function completes as normal but returns only $true if the Reference is valid and $false otherwise.
This is used in parameter definition blocks as part of a ValidateScript attribute.
#>
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
                    $Validation ? $true : $_.id
                }
                else {
                    Write-Warning "Find-ObjectIdByReference: Schema mismatch: Expected '$Schema' but got '$($_.objectschema)'"
                    $null
                }
            }
            { $_.objectschema -and -not $Schema } { $Validation ? $true : $_.id }
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