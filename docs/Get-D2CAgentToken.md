# Get-D2CAgentToken

## SYNOPSIS
Gets a Direct-to-Cloud (D2C) agent token for a client and vault.

## SYNTAX

```PowerShell
Get-D2CAgentToken [-Client] <Object[]> [-Vault] <Object> [-PassThru] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-D2CAgentToken function retrieves a Direct-to-Cloud (D2C) agent token for a specified client and vault.
This token is used for authenticating D2C agents with the Axcient cloud service.

## EXAMPLES

### EXAMPLE 1
```PowerShell
Get-D2CAgentToken -Client 123 -Vault 456
```

This example retrieves a D2C agent token for client ID 123 and vault ID 456.

### EXAMPLE 2
```PowerShell
$client | Get-D2CAgentToken -Vault 789
```

This example retrieves a D2C agent token for the client object in the pipeline and vault ID 789.

### EXAMPLE 3
```PowerShell
Get-D2CAgentToken -Client $clientObj -Vault $vaultObj -PassThru
```

This example retrieves a D2C agent token for the specified client and vault objects, and adds the token_id to the client object.

## PARAMETERS

### -Client
Specifies the client for which to retrieve the D2C agent token.
Can be a client ID (integer) or a client object with an 'id' property.

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

### -Vault
Specifies the vault for which to retrieve the D2C agent token.
Can be a vault ID (integer) or a vault object with an 'id' property.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
If specified, adds the token_id as a property to the input Client object instead of returning a new object.

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

A client object

##OUTPUTS

[PSCustomObject]
Returns a custom object with client_id, vault_id, token_id, and objectschema properties.