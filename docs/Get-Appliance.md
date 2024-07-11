# Get-Appliance

## SYNOPSIS
Get information about an Appliance.

## SYNTAX

### All (Default)
```
Get-Appliance [-ServiceID <String>] [-IncludeDevices <Boolean>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Appliance
```
Get-Appliance [-Appliance <Object>] [-IncludeDevices <Boolean>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Client
```
Get-Appliance [-Client <Object>] [-IncludeDevices <Boolean>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Pipeline
```
Get-Appliance [-IncludeDevices <Boolean>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Gets information about appliances.
Can accept Appliance or Client objects from the pipeline or from parameters.
You can also specify an appliance by its service ID.

## EXAMPLES

### EXAMPLE 1
```
Get-Appliance
# Returns all appliances avaialble to the user account at this organization
```

### EXAMPLE 2
```
Get-Appliance -Appliance 12345
```

### EXAMPLE 3
```
$client | Get-Appliance
```

## PARAMETERS

### -Appliance
Appliance object or ID to retrieve information on.

```yaml
Type: Object
Parameter Sets: Appliance
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Client
Specifies the client object or reference to retrieve information for all appliances associated with a specific client.

```yaml
Type: Object
Parameter Sets: Client
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceID
Specifies the service ID of the appliance.
Must be a 4-character alphanumeric string.

```yaml
Type: String
Parameter Sets: All
Aliases: service_id

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDevices
Indicates whether to include device information along with the appliance information.
By default, it is set to $true.

```yaml
Type: Boolean
Parameter Sets: (All)
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

### Appliance or Client object
## OUTPUTS

### An Appliance object or array or Appliance objects
## NOTES

## RELATED LINKS
