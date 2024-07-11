# Get-Vault

## SYNOPSIS
Get information about vaults

## SYNTAX

### All (Default)
```
Get-Vault [-Type <String>] [-Active <Boolean>] [-WithUrl <Boolean>] [-Limit <Int32>]
 [-IncludeDevices <Boolean>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Vault
```
Get-Vault [-Vault <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get information about a vaults related to an organization or on a specific vault.
If requesting
information for all vaults you can filter by type, state, and URL presence.

## EXAMPLES

### EXAMPLE 1
```
Get-Vault -Vault 12345
```

### EXAMPLE 2
```
Get-Vault -Type 'Private' -Active $true -WithUrl $true -IncludeDevices $false
```

## PARAMETERS

### -Vault
Vault object or ID to retrieve information on.

```yaml
Type: Object
Parameter Sets: Vault
Aliases: Id

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Type
Specifies the type of vaults to retrieve.
Valid values are 'Private' and 'Cloud'.
Returns both
types if not specified.

```yaml
Type: String
Parameter Sets: All
Aliases: vault_type

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Active
Specifies whether to retrieve active vaults only.
If set to $true, only active vaults will be
retrieved.
If set to $false, only inactive vaults will be retrieved.
If not set, the result
is not filtered by active state.

```yaml
Type: Boolean
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WithUrl
Filter on presence of URL.
If true, only vaults with a URL will be retrieved.
If false, only vaults
without a URL will be retrieved.
If not set, the result is not filtered by URL presence.

```yaml
Type: Boolean
Parameter Sets: All
Aliases: with_url

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Specifies the maximum number of vaults to retrieve.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDevices
Specifies whether to include devices associated with the vaults in the retrieved information.
If set to $true, devices will be included.

```yaml
Type: Boolean
Parameter Sets: All
Aliases: include_devices

Required: False
Position: Named
Default value: True
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

### Pipeline input is not accepted.
## OUTPUTS

### Returns a Vault object or array of Vault objects
###     [PSCustomObject],[PScustomObject[]]
## NOTES

## RELATED LINKS
