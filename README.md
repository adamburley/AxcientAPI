# Axcient x360 Recover API

![PowerShell Gallery Platform Support](https://img.shields.io/powershellgallery/p/axcientapi)
![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/axcientapi)
![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/axcientapi)
![GitHub License](https://img.shields.io/github/license/adamburley/AxcientAPI)
[![#v-axcient on MSPGeek Discord](https://img.shields.io/discord/801971115013963818?logo=discord&logoColor=white&label=MSPGeek%20%23v-axcient)](https://discord.com/channels/801971115013963818/1020766171978543204)

![GitHub last commit](https://img.shields.io/github/last-commit/adamburley/AxcientAPI)
![Code Coverage](https://img.shields.io/badge/coverage-73%25-orange.svg?maxAge=60)

In June 2024, Axcient announced a public API for their x360 Recover backup product is in early access.

[Announcement post](https://axcient.com/blog/axcient-public-apis/)

Currently Axcient is accepting requests for access to the production environment, and offers a mock / dev environment through a Swagger editor at https://developer.axcient.com/. An OpenAPI YAML file is also available at that page.

This module conforms to endpoints published as of 6/25/2024 and as such supports _read-only_ access and user-based API keys only. Future changes will be accomodated as they are announced.

As the API itself is in early access and likely to change, this should not be considered a production-ready module. However, I have made efforts to introduce no novel bugs. Please raise issues as they are found.

## Status

Version `0.2.0` reflects July 2024 schema changes.

The module is usable. Testing is ongoing.

Once documentation is complete and additional testing is successful this will be published to the PowerShell Gallery.

## Getting Started

**Compatibility**: PowerShell 7 Core. OS Agnostic, works in PS Core / Azure Function Apps

```Install-Module AxcientAPI``` or ```Install-PSResource AxcientAPI```

```PowerShell
PS > Import-Module AxcientAPI
PS > Initialize-AxcientAPI -ApiKey 'yourlongkey' # -MockServer if testing against the Mock endpoint
PS > Get-Organization

id_           : 26
name          : Spacely Sprockets
active        : True
brand_id      : SPACELY
salesforce_id : 8675309
objectschema  : organization

```

## Functions

| Function | Description |
| --- | --- |
| [Get-Appliance](./docs/Get-Appliance.md) | Get information about an Appliance. |
| [Get-BackupJob](./docs/Get-BackupJob.md) | Get backup job information for a device. |
| [Get-BackupJobHistory](./docs/Get-BackupJobHistory.md) | Get history of runs for a backup job. |
| [Get-Client](./docs/Get-Client.md) | Retrieves information on a client or clients |
| [Get-Device](./docs/Get-Device.md) | Retrieves information about devices. |
| [Get-DeviceAutoVerify](./docs/Get-DeviceAutoVerify.md) | Retrieves auto-verify information for one or more devices. |
| [Get-DeviceRestorePoint](./docs/Get-DeviceRestorePoint.md) | Retrieves restore points for a device. |
| [Get-Organization](./docs/Get-Organization.md) | Retrieves information about the partner organization. |
| [Get-Vault](./docs/Get-Vault.md) | Get information about vaults |
| [Initialize-AxcientAPI](./docs/Initialize-AxcientAPI.md) | Prepares for calls to the Axcient API. |

## Custom properties

Due to limitations in the API (as of the July 2024 release) two sets of custom properties are included in objects handled by this module.

- **[objectschema](ApiNotes.md#schema-property)** identifies the type of object to improve error-catching and pipeline compatibility.
- **[parent_id](ApiNotes.md#parent-id-properties)** adds properties to identify the parents of an object, when available (e.g. `client_id`, `device_id`).

You can read more about the implementation of each at the links above.

## TODO / Features wanted

1. [x] Devices do not carry client ID in the object, making them hard to pipe _Currently implemented by the module, not the API_
2. [ ] Consider custom objects / classes
3. [ ] Testing with Pester [*In progress*]



