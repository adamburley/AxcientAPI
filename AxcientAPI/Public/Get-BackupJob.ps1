function Get-BackupJob {
    [CmdletBinding(DefaultParameterSetName = 'Device')]
    param (        
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'device' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Device,

        [Parameter()]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Client,

        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Schema 'client' -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$Job,

        [Parameter()]
        [ValidateScript({ Find-ObjectIdByReference -Reference $_ -Validation }, ErrorMessage = 'Must be a positive integer or matching object' )]
        [object]$InputObject
    )
    begin {
        $_deviceId = Find-ObjectIdByReference $Device
        $_clientId = Find-ObjectIdByReference $Client 
        if ($Client) {
            $_clientId = Find-ObjectIdByReference $Client
        }
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Device') {
            $_clientId = $_clientId ?? $thisDevice.client_id
            if (-not $_clientId) {
                Write-Error -Message "Get-BackupJob: No client_id found on device object. Specify with -Client parameter."
                continue
            }
            $_deviceId = Find-ObjectIdByReference $thisDevice
            $call = Invoke-AxcientAPI -Endpoint "client/$_clientId/device/$_deviceId/job" -Method Get
            if ($call.error) {
                $_errorMessage = $call.error.Message
                Write-Error -Message "Get-Client returned $_errorMessage"
                $call
            }
            $call
            else {
                $call | Foreach-Object { 
                    $_ | Add-Member -MemberType NoteProperty -Name 'client_id' -Value $_clientId -PassThru | 
                    Add-Member -MemberType NoteProperty -Name 'device_id' -Value $thisDevice.Id_ -PassThru |
                    Add-Member -MemberType NoteProperty -Name 'objectschema' -Value 'job' -PassThru
                }
            }
        } else {
            
        }
    }
}