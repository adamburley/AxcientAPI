# Get-Organization

## SYNOPSIS
Retrieves information about the partner organization.

## SYNTAX

```PowerShell
Get-Organization [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves basic information about the partner organization related to the authenticating
user API Key.

## EXAMPLES

### EXAMPLE 1
```PowerShell
PS > Get-Organization

id            : 26
name          : Spacely Sprockets
active        : True
brand_id      : SPACELY
salesforce_id : reseller_salesforce_id
```
## PARAMETERS

This function does not have any parameters.

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## OUTPUTS

### [PSCustomObject]
Representation of organization data