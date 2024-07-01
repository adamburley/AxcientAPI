BeforeAll {
    Import-Module $PSScriptRoot\..\..\Output\AxcientAPI -Force
}
 
Describe "Find-ObjectIdByReference" {
    InModuleScope AxcientAPI {
        Context "Successful results" {
            BeforeAll{
                $testDevice = [PSCustomObject]@{
                    Id_ = 42
                    objectschema = 'device'
                }
            }
            It 'Receives an integer' {
                Find-ObjectIdByReference -Reference 0 | Should -Be 0
            }
            It 'Receives a string' {
                Find-ObjectIdByReference -Reference '1' | Should -Be 1
            }
            It 'Receives $null' {
                Find-ObjectIdByReference -Reference $null | Should -Be $null
            }
            It 'Receives an object' {
                Find-ObjectIdByReference -Reference $testDevice | Should -Be 42
            }
            It 'Receives an object with schema validation' {
                Find-ObjectIdByReference -Reference $testDevice -Schema 'device' | Should -Be 42
            }
            It 'Validates an integer' {
                Find-ObjectIdByReference -Reference 42 -Validation | Should -Be $true
            }
            It 'Validates zero' {
                Find-ObjectIdByReference -Reference 0 -Validation | Should -Be $true
            }
            It 'Validates a string' {
                Find-ObjectIdByReference -Reference '42' -Validation | Should -Be $true
            }
            It 'Validates $null' {
                Find-ObjectIdByReference -Reference $null -Validation | Should -Be $null
            }
            It 'Validates an object' {
                Find-ObjectIdByReference -Reference $testDevice -Validation | Should -Be $true
            }
            It 'Validates an object with schema validation' {
                Find-ObjectIdByReference -Reference $testDevice -Schema 'device' -Validation | Should -Be $true
            }
        }
        Context "Unsuccessful and Output" {
            BeforeAll {
                Mock Write-Warning { }
                $testDevice = [PSCustomObject]@{
                    Id_ = 42
                    objectschema = 'device'
                }
            }
            It 'Warns on unparseable string' {
                #Mock Write-Warning { }
                Find-ObjectIdByReference -Reference 'not a number'
                Should -Invoke Write-Warning -ParameterFilter { $Message -eq 'Find-ObjectIdByReference: Unable to parse string to Int: not a number' }
            }
            It 'Warns on schema mismatch' {

                Find-ObjectIdByReference -Reference $testDevice  -Schema 'client' | Should -Be $null
                Should -Invoke Write-Warning -ParameterFilter { $Message -eq "Find-ObjectIdByReference: Schema mismatch: Expected 'client' but got 'device'" }
            }
            It 'Warns on unknown object' {
                #Mock Write-Warning { }
                Find-ObjectIdByReference -Reference ([PSCustomObject]@{
                    Name = "Hi I'm invalid."
                })
                Should -Be $null
                Should -Invoke Write-Warning -ParameterFilter { $Message -eq "Find-ObjectIdByReference: Could not parse object reference: @{Name=Hi I'm invalid.}" }

            }
            It 'Writes to debug' {
                Mock Write-Debug { }
                Find-ObjectIdByReference -Reference 42
                Should -Invoke Write-Debug -ParameterFilter { $Message -eq 'Find-ObjectIdByReference: 42' }
            }
        }
    }
}