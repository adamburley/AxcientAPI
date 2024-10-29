# Get-VaultThreshold

## SYNOPSIS
Retrieves a threshold value for a vault.

## SYNTAX

```
Get-VaultThreshold [-Vault] <Object> [[-Type] <String>] [-PassThru] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-VaultThreshold function retrieves the threshold value for a specified vault.
Currently the only threshold available is connectivity, in minutes.
If additional thresholds
become available in the future they will be added via the -Type parameter.

By default returns a custom object for the threshold value.
Provide a Vault object and specify
-PassThru and it will return a Vault object with the vault_thresholds property populated.

## EXAMPLES

### EXAMPLE 1
```PowerShell
Get-VaultThreshold -Vault 123

vault_id     : 123
type         : Connectivity
threshold    : 240
objectschema : vault.threshold
```
### EXAMPLE 2
```PowerShell
$vault = $vault | Get-VaultThreshold -PassThru
PS > $vault | select id, vault_thresholds

id               : 14536
vault_thresholds : @{connectivity_threshold=240}
```

This example retrieves the threshold for the vault object in $vault and adds the threshold value to the vault object.

## PARAMETERS

### -Vault
Specifies the vault for which to retrieve the threshold.
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

### -Type
Specifies the type of threshold to retrieve.
Currently, only 'Connectivity' is supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Connectivity
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
When specified, and when a vault object is provided as input, the function will return the input object with the threshold value added to it.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

[PSCustomObject]

Accepts a Vault object from the pipeline

## OUTPUTS


[PSCustomObject]

A vault.threshold object or a Vault object

## RELATED LINKS

[Set-VaultThreshold](./Set-VaultThreshold.md)

[Get-Vault](./Get-Vault.md)

