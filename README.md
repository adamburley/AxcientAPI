# Axcient x360 Recover API

In June 2024, Axcient announced a public API for their x360 Recover backup product is in early access.

[Announcement post](https://axcient.com/blog/axcient-public-apis/)

Currently Axcient is accepting requests for access to the production environment, and offers a mock / dev environment through a Swagger editor at https://developer.axcient.com/. An OpenAPI YAML file is also available at that page.

This module conforms to endpoints published as of 6/25/2024 and as such supports _read-only_ access and user-based API keys only. Future changes will be accomodated as they are announced.

As the API itself is in early access and likely to change, this should not be considered a production-ready module. However, I have made efforts to introduce no novel bugs. Please raise issues as they are found.

## Status

As of `0.1.0` the module is successfully calling the production API. See releases to download the built module files.  
Once documentation is complete and additional testing is successful this will be published to the PowerShell Gallery.

## Getting Started

**PowerShell 7 Required. Should be compatible with all implementations of PowerShell Core.**

```PowerShell
PS > Import-Module .\AxcientAPI
PS > Initialize-AxcientAPI -ApiKey 'idontwantalimelessonijustwanticecream' # Add -MockServer if testing against the Mock
PS > Get-Organization

id_           : 26
name          : Spacely Sprockets
active        : True
brand_id      : SPACELY
salesforce_id : 8675309a
objectschema  : organization

```

## Functions

### Organization

| Function         | Endpoint        | Notes |
| ---------------- | --------------- | ----- |
| Get-Organization | `/organization` |       |

### Client

| Function   | Endpoint              | Schema   | Notes |
| ---------- | --------------------- | -------- | ----- |
| Get-Client | `/client`             | `client` |       |
| Get-Client | `/client/{client_id}` | `client` |       |

### Device

| Function         | Endpoint                            | Schema                | Notes |
| ---------------- | ----------------------------------- | --------------------- | ----- |
| Get-Device       | `/client/{client_id}/device`        | `device`              |       |
| Get-Device       | `/device/{device_id}`               | `device`              |       |
| Get-AutoVerify   | `/device/{device_id}/autoverify`    | `device.autoverify`   |       |
| Get-RestorePoint | `/device/{device_id}/restore_point` | `device.restorepoint` |       |

### Job

| Function             | Endpoint                                                      | Schema        | Notes                                                                                                                         |
| -------------------- | ------------------------------------------------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Get-BackupJob        | `/client/{client_id}/device/{device_id}/job`                  | `job`         |                                                                                                                               |
| Get-BackupJob        | `/client/{client_id}/device/{device_id}/job/{job_id}`         | `job`         |                                                                                                                               |
| Get-BackupJobHistory | `/client/{client_id}/device/{device_id}/job/{job_id}/history` | `job.history` | **THIS ENDPOINT IS NONFUNCTIONAL**. A bug prevents a successful call. The function may be used but displays a warning. See #3 |

### Appliance

| Function      | Endpoint                        | Schema      | Notes |
| ------------- | ------------------------------- | ----------- | ----- |
| Get-Appliance | `/appliance`                    | `appliance` |       |
| Get-Appliance | `/client/{client_id}/appliance` | `appliance` |       |
| Get-Appliance | `/appliance/{appliance_id}`     | `appliance` |       |

### Vault

| Function            | Endpoint                                    | Schema  | Notes                                                                                             |
| ------------------- | ------------------------------------------- | ------- | ------------------------------------------------------------------------------------------------- |
| Get-Vault           | `/vault`                                    | `vault` |                                                                                                   |
| Get-Vault           | `/vault/{vault_id}`                         | `vault` |                                                                                                   |
| Get-Vault           | `/vault/{vault_id}/threshhold/connectivity` |         | This appears redundant to the standard vault call. Ommitting until more information is available. |
| POST - Connectivity | `/vault/{vault_id}/threshhold/connectivity` |         | Omitting until more information regarding this endpoint is available.                             |

## Parent ID Properties

Because the API does not currently implement parent object IDs in responses they are added by the module using property names `client_id`, `device_id`, etc.

Where endpoints require such data - for example _Get-BackupJob_ - these properties are used if included in the presented object.

In cases where a parent ID is not available - such as calling _Get-Device_ with a specified Device ID integer - the property is present, but empty. You can specify the requisite value by populating the property or by passing the value as a parameter where needed.

```PowerShell
# Client ID is available in the Device object
PS > $device = Get-Device -Client 42 | Select -First 1
PS > $device.client_id; $device.id_
42
67

PS > $job = $device | Get-Job | Select -First 1
PS > $job.client_id; $job.device_id
42
67

# Client ID is not available. Error result.
PS > $device = Get-Device -Id 42
PS > $device.client_id; $device.id_

67

PS > $job = $device | Get-Job
ERROR: Get-BackupJob: Missing client ID on device object. Specify with -Client parameter.

# Providing by updating object property
PS > $device.client_id = 42
PS > $device | Get-Job

# Or specify as a parameter

PS > $device | Get-Job -Client 42
```

## Schema Property

The property `objectschema` is added to each object returned by a function. This enables more effective use of pipelines.

It's possible this will be replaced at a later date by the implementation of object classes.

## Known differences between Mock and Prod

1. Auth header mismatch. Intro to endpoint documentation lists authentication header as `x-api-headers`, however the production environment expects an `x-api-key` header. The correct header IS listed in the swagger demo / OpenAPI specification.
2. Some endpoints return errors in the mock if a trailing slash is used. E.g. `/client` returns data, `/client/` returns an error. This is not replicated in the production environment.
3. Errors. See **Error Handling** for specifics related to the API itself. Known response formats are handled by the module itself and will return informative messaging where possible. To retrieve the full contents of an error message enable them when initializing the connection: `Invoke-AxcientAPI -ReturnErrors`
4. The Job History endpoint is nonfunctional. See #3

## Error Handling

Errors return different values in different situations. This is a collection of raw results identified so far (as of 2024-7-10). When calling from the module, errors are handled gracefully where possible and provide informative responses.  
If an error response does not contain a parseable body, the module will create a similar response with the type `UndefiniedHTTPErrorResponse`. TODO: Test if all endpoints return robust error responses.

### Invalid API Key:

- HTTP Status: 401
- Content-Type: `application/json`
- Body:

```json
{ "message": "Unauthorized" }
```

### Invalid URI

This includes both invalid endpoints (`/organisation`) and invalid path-based input (`/client/thisshouldbeanumber`). Per the API specification Invalid / not-a-number errors should return HTTP 400 but do not.

- HTTP Status: 401
- Content-Type: `text/html; charset=utf-8`
- Body

```json
{ "code": 401, "msg": "Unauthorized" }
```

### Not Found

- HTTP Status: 404,
- Content-Type: `application/problem+json`
- Body (formatted as byte array):

```json
{
  "detail": "Client with such id = 12 is not found",
  "status": 404,
  "title": "Client not found",
  "type": "NotFoundException"
}
```

### Bad Request

At least one endpoint - Job History - returns with a similar format.

- HTTP Status: 400
- Content-Type: `application/problem+json`
- Body (as byte array):

```json
{
  "detail": "Missing path parameter 'org_id'",
  "status": 400,
  "title": "Bad Request",
  "type": "about:blank"
}
```

## TODO / Features wanted

1. [x] Devices do not carry client ID in the object, making them hard to pipe _Currently implemented by the module, not the API_
2. [ ] Consider custom objects / classes
3. [ ] Testing with Pester [*In progress*]
