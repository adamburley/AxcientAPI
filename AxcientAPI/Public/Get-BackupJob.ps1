# to support checking multiple devices for the same client, we'll use the device object as the pipeable one
function Get-BackupJob {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ ($_ -is [int] -and $_ -ge 0) -or [bool]($_ | Get-Member -Name 'Id_') }, ErrorMessage = 'ClientId must be a positive integer or a client object with an Id_ property')]
        [object]$ClientId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id_')]
        [int[]]$DeviceId,

        [Parameter()]
    )
    
    begin {
    }
    
    process {
        
    }
    
    end {
        
    }
}