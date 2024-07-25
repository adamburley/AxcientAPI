# Initialize-AxcientAPI

## SYNOPSIS
Sets API key, server URL, and error handling for AxcientAPI module functions.

## SYNTAX

```PowerShell
Initialize-AxcientAPI [-ApiKey] <String> [-MockServer] [-ReturnErrors] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Initialize-AxcientAPI sets the API key and server URL for AxcientAPI module functions.
The API key is required for both production and mock environments.By default the production
server URL is utilized.

Use the -MockServer switch to specify the mock environment.

## EXAMPLES

### EXAMPLE 1
```PowerShell
Initialize-AxcientAPI -ApiKey "imalumberjackandimokay" -MockServer -ReturnErrors
```

## PARAMETERS

### -ApiKey
API key to authenticate the connection.

```yaml
Type: String
Required: True
Position: 1
Default value: None
```
### -MockServer
Specifies whether to use the mock server for testing purposes.

```yaml
Type: SwitchParameter
Required: False
Position: Named
Default value: False
```

### -ReturnErrors
When set, module functions will return the error object if an API call fails.
By default nothing is returned
on failure.

```yaml
Type: SwitchParameter
Required: False
Position: Named
Default value: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## NOTES
As of module version 0.3.0 and the July 2024 API release the error schema is not well-defined.
The module
attempts to return a consistent object of its own design.
