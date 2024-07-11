# Get-BackupJob

## SYNOPSIS
Get backup job information for a device.

## SYNTAX

```
Get-BackupJob [[-Device] <Object>] [[-Client] <Object>] [[-Job] <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves the Job configuration for a device.
May return more than one Job.

## EXAMPLES

### EXAMPLE 1
```
Get-BackupJob -Device 12345 -Client 67890 -Job 54321
```

### EXAMPLE 2
```
# Get all Jobs for all devices for a client.
PS > Get-Client -Client 49282 | Get-Device | Get-BackupJob
```

## PARAMETERS

### -Device
Device to retrieve information for.
Accepts device ID or Device Object.
If specifying a device
object, function will also use Client ID if available.
Not required if present on Job object

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Client
Relevant Client ID or Object.
Not required if Client ID is avilable on Device or Job object

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Job
A specific Job to retrieve information for.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
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

### Accepts Device or Job objects. If Client ID or Device ID is not present on passed object it must
### be specified as a separate parameter.
## OUTPUTS

### A Job object or array of Job objects
## NOTES

## RELATED LINKS
