# Get-BackupJobHistory

## SYNOPSIS
Get history of runs for a backup job.

## SYNTAX

```PowerShell
Get-BackupJobHistory [[-Device] <Object>] [[-Client] <Object>] [-Job] <Object> [[-StartTimeBegin] <DateTime>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves run history for a backup job

## EXAMPLES

### Specify parameters
```PowerShell
Get-BackupJobHistory -Device 12345 -Client 67890 -Job 54321
```

### Piped job
```PowerShell
$job | Get-BackupJobHistory
```

### Start time begin - last 30
```PowerShell
$job | Get-BackupJobHistory -StartTimeBegin (Get-Date).AddDays(-30)
```

This example returns history only for jobs starting less than 30 days ago


### Start time begin - date time string
```PowerShell
$job | Get-BackupJobHistory -StartTimeBegin '2024-08-12'
```
This example returns history for jobs starting after August 12, 2024 00:00


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

### -StartTimeBegin
The oldest date / time start time you want to return history for.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: starttime_begin

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

[PSCustomObject]
Job objects

## OUTPUTS

[PSCustomObjects]
Job history objects

## NOTES
As of v0.4.0 this function utilizes pagination to ensure all results are returned.
History is requested in sets of 1500.