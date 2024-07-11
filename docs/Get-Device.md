# Get-Device

## SYNOPSIS
Retrieves information about devices.

## SYNTAX

### Client (Default)
```
Get-Device -Client <Object[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Device
```
Get-Device -Device <Object[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves information about protected devices, including agent status, version, IP Address,
host OS, and more.
You can specify by Client or Device.

## EXAMPLES

### EXAMPLE 1
```
$client | Get-Device
# Returns a list of devices for the given client
```

### EXAMPLE 2
```
Get-Device -Client $client,$client2
# Returns a list of devices for two clients
```

### EXAMPLE 3
```
Get-Device -Device 12345
```

### EXAMPLE 4
```
Get-Device -Device $myDevice
```

## PARAMETERS

### -Client
Client to retrieve a list of devices for.
Accepts one or more integer client IDs or objects.
You may pipe Client objects to this function.

```yaml
Type: Object[]
Parameter Sets: Client
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Device
A specific device or devices to retrieve information for.
Accepts one or more integer device
IDs or objects.

```yaml
Type: Object[]
Parameter Sets: Device
Aliases: Id

Required: True
Position: Named
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

### Client objects
## OUTPUTS

### A Device object or array of Device objects
## NOTES

## RELATED LINKS
