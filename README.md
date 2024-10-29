![Axcient Logo](https://axcient.com/wp-content/webp-express/webp-images/doc-root/wp-content/uploads/2023/11/logo_main.png.webp)
# Axcient x360Recover API

![PowerShell Gallery Platform Support](https://img.shields.io/powershellgallery/p/axcientapi)
![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/axcientapi)
![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/axcientapi)
![GitHub License](https://img.shields.io/github/license/adamburley/AxcientAPI)
[![#v-axcient on MSPGeek Discord](https://img.shields.io/discord/801971115013963818?logo=discord&logoColor=white&label=MSPGeek%20%23v-axcient)](https://discord.com/channels/801971115013963818/1020766171978543204)

![GitHub last commit](https://img.shields.io/github/last-commit/adamburley/AxcientAPI)
![Code Coverage](https://img.shields.io/badge/coverage-89%25-yellow.svg?maxAge=60)

In June 2024, Axcient announced a public API for their x360Recover backup product is in early access.

[Announcement post](https://axcient.com/blog/axcient-public-apis/)

Currently Axcient is accepting requests for access to the production environment, and offers a mock / dev environment, Swagger Editor and OpenAPI schema at https://developer.axcient.com/.

⚠️ As the API itself is in early access and likely to change, this should not be considered a production-ready module. However, I have made efforts to introduce no novel bugs. Please raise issues as they are found.

## Status

Version 0.4.0 updated October 19, 2024.  Aligns with version 0.3.1 of API.

Version 0.4.0 adds new endpoints and resolves several issues.

Manual and automated testing against the mock and prod environments is successful.  Please raise issues as found.

## Getting Started

**Compatibility**: PowerShell 7 Core. OS Agnostic, works in Windows console, PS Core / Azure Function Apps

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

| Function | Synopsis |
| --- | --- |
| [Get-Appliance](./docs/Get-Appliance.md) | Get information about an Appliance. |
| [Get-BackupJob](./docs/Get-BackupJob.md) | Get backup job information for a device. |
| [Get-BackupJobHistory](./docs/Get-BackupJobHistory.md) | Get history of runs for a backup job. |
| [Get-Client](./docs/Get-Client.md) | Retrieves information on a client or clients |
| [Get-D2CAgentToken](./docs/Get-D2CAgentToken.md) | Gets a Direct-to-Cloud (D2C) agent token for a client and vault. |
| [Get-Device](./docs/Get-Device.md) | Retrieves information about devices. |
| [Get-DeviceAutoVerify](./docs/Get-DeviceAutoVerify.md) | Retrieves auto-verify information for one or more devices. |
| [Get-DeviceRestorePoint](./docs/Get-DeviceRestorePoint.md) | Retrieves restore points for a device. |
| [Get-Organization](./docs/Get-Organization.md) | Retrieves information about the partner organization. |
| [Get-Vault](./docs/Get-Vault.md) | Get information about vaults |
| [Get-VaultThreshold](./docs/Get-VaultThreshold.md) | Retrieves a threshold value for a vault. |
| [Initialize-AxcientAPI](./docs/Initialize-AxcientAPI.md) | Sets API key, server URL, and error handling for AxcientAPI module functions. |
| [Set-VaultThreshold](./docs/Set-VaultThreshold.md) | Sets a threshold value for a vault. |

## Custom properties

Due to limitations in the API (as of the July 2024 release) two sets of custom properties are included in objects handled by this module.

- **[objectschema](ApiNotes.md#schema-property)** identifies the type of object to improve error-catching and pipeline compatibility.
- **[parent_id](ApiNotes.md#parent-id-properties)** adds properties to identify the parents of an object, when available (e.g. `client_id`, `device_id`).

You can read more about the implementation of each at the links above.

## TODO / Features wanted

1. [x] Devices do not carry client ID in the object, making them hard to pipe _Currently implemented by the module, not the API_
2. [ ] Consider custom objects / classes
3. [X] Testing with Pester [*Core testing complete*]
