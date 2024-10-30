# Set-VaultThreshold

## SYNOPSIS
Sets a threshold value for a vault.

## SYNTAX

```
Set-VaultThreshold [-Vault] <Object> [-ThresholdMinutes] <Int32> [[-Type] <String>] [-PassThru]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Get-VaultThreshold function sets the threshold value for a specified vault.
Currently the only threshold available is connectivity, in minutes.
If additional thresholds
become available in the future they will be added via the -Type parameter.

By default returns a custom object for the threshold value.
Provide a Vault object and specify
-PassThru and it will return a Vault object with the vault_thresholds property populated.

## EXAMPLES

### EXAMPLE 1
```PowerShell
Set-VaultThreshold -Vault 123 -ThresholdMinutes 120

vault_id     : 123
type         : Connectivity
threshold    : 120
objectschema : vault.threshold
```
### EXAMPLE 2
```PowerShell
$vault = $vault | Get-VaultThreshold -ThresholdMinutes 120 -PassThru
PS > $vault | select id, vault_thresholds

id               : 1454132
vault_thresholds : @{connectivity_threshold=120}
```
This example updates the threshold and returns the new value within the vault object.

## PARAMETERS

### -Vault
Specifies the vault for which to set the threshold.
This can be a vault ID (integer) or a vault object.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ThresholdMinutes
{{ Fill ThresholdMinutes Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Specifies the type of threshold to set.
Currently, only 'Connectivity' is supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Connectivity
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
When specified, and when a vault object is provided as input, the function will return the input object with the updated
threshold value added to it.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

[PSCustomObject]
Accepts a Vault object from the pipeline

## OUTPUTS

[PSCustomObject]
A vault.threshold object or a Vault object

## NOTES

## RELATED LINKS

[Get-VaultThreshold](./Get-VaultThreshold.md)

