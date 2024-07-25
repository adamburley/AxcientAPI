# Get-DeviceRestorePoint

## SYNOPSIS
Retrieves restore points for a device.

## SYNTAX

```PowerShell
Get-DeviceRestorePoint [-Device] <Object[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
For each specified device, returns an object with current status and a list of restore points.

## EXAMPLES

### EXAMPLE
```PowerShell
PS > $devices = Get-Device
PS > $restorePoints = $devices | Get-DeviceRestorePoint
```

## PARAMETERS

### -Device
One or more Device objects or integers to retrieve restore points for.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

Restore point object

## OUTPUTS

Restore point object or array of Restore point objects