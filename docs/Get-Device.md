# Get-Device

## SYNOPSIS
Retrieves information about devices.

## SYNTAX

### All (Default)
```PowerShell
Get-Device [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Client
```PowerShell
Get-Device [-Client <Object[]>] [-ServiceId <String>] [-D2COnly] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Device
```PowerShell
Get-Device [-Device <Object[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves information about protected devices, including agent status, version, IP Address,
host OS, and more.
You can specify by Client or Device.
If no parameters are provided, the
function returns all devices available under the authenticated account.

## EXAMPLES

### All Devices
```PowerShell
Get-Device
```
Returns a list of all devices available under the authenticated account.

Note: This parameter set paginates calls in offsets of 100 to retrieve all devices.


### Client Devices
```PowerShell
$client | Get-Device
```

Returns a list of devices for the given client

### Client Devices - 2
```PowerShell
Get-Device -Client $client,$client2
```
Returns a list of devices for two clients

### Specific device
```PowerShell
Get-Device -Device 12345
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

Required: False
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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceId
The four-character service id for the desired device.
Only available when specifying a client

```yaml
Type: String
Parameter Sets: Client
Aliases: service_id

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -D2COnly
Return D2C devices only.
Available when specifying a client
Note: This parameter is ignored if ServiceId is specified

```yaml
Type: SwitchParameter
Parameter Sets: Client
Aliases: d2c_only

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

Client objects

## OUTPUTS

A Device object or array of Device objects