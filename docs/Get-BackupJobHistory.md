# Get-BackupJobHistory

## SYNOPSIS
Get history of runs for a backup job.

## SYNTAX

```PowerShell
Get-BackupJobHistory [[-Device] <Object>] [[-Client] <Object>] [-Job] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves run history for a backup job

## EXAMPLES

### Specify parameters
```PowerShell
Get-BackupJobHistory -Device 12345 -Client 67890 -Job 54321
```

### Piped job object
```PowerShell
$job | Get-BackupJobHistory
```

Retrieve history for a specific job.

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

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

Job objects

## OUTPUTS

A Job history object or an array of Job history objects

## NOTES
This endpoint currently has a bug.
Function logic is cohesive but untested.
It may be attempted, a warning will display.
Once bug is resolved this warning will be removed.
#GH-3 -2024-07-11
