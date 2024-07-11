# Get-AutoVerify

## SYNOPSIS
Retrieves auto-verify information for one or more devices.

## SYNTAX

```
Get-AutoVerify [-Device] <Object[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns information about auto-verify tests.
Each device returns an auto-verify object with one or
more runs detailed.

## EXAMPLES

### EXAMPLE 1
```
Get-AutoVerify -Device $device1, $device2
Retrieves auto-verify information for $device1 and $device2.
```

### EXAMPLE 2
```
$clientDevices | Get-AutoVerify
Returns auto-verify information for all devices.
```

## PARAMETERS

### -Device
The device or devices to retrieve auto-verify information.
Accepts integer IDs or Device objects.
Accepts from the pipeline.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Device objects
## OUTPUTS

### An Autoverify object or array of Autoverify objects.
## NOTES

## RELATED LINKS
