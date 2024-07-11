# Get-Client

## SYNOPSIS
Retrieves information on a client or clients

## SYNTAX

### All (Default)
```
Get-Client [-IncludeAppliances] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Client
```
Get-Client [-Client <Object[]>] [-IncludeAppliances] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves information for for one or multiple clients, including client ID, name, health status,
and device counters.
Optionally basic information about the client's appliances can be included.

## EXAMPLES

### EXAMPLE 1
```
$clients = Get-Client
PS > $clients.Count
42
```

### EXAMPLE 2
```
$oneClientFreshData = Get-Client -Client $clients[0]
# Returns updated client information
```

### EXAMPLE 3
```
$oneClientFreshData = $clients[0] | Get-Client -IncludeAppliances
# Returns updated client information, now with basic appliance information
```

### EXAMPLE 4
```
$oneClient = Get-Client -Client 12345
PS > $oneClient.id_
12345
```

## PARAMETERS

### -Client
Client or clients to retrieve information for.
Accepts one or more integer client IDs or objects.
Parameter accepts from the pipeline.

```yaml
Type: Object[]
Parameter Sets: Client
Aliases: Id

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -IncludeAppliances
Return basic information about appliances for this client.

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

### Accepts a Client object.
## OUTPUTS

### Returns a Client object or array of Client objects.
## NOTES

## RELATED LINKS
