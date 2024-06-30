# Axcient x360 Recover API

In June 2024, Axcient announced a public API for their x360 Recover backup product is in early access.

[Announcement post](https://axcient.com/blog/axcient-public-apis/)

Currently Axcient is accepting requests for access to the production environment, and offers a mock / dev environment through a Swagger editor at https://developer.axcient.com/. An OpenAPI YAML file is also available at that page.

This module conforms to endpoints published as of 6/25/2024 and as such supports _read-only_ access and user-based API keys only. Future changes will be accomodated as they are announced.

As the API itself is in early access and likely to change, this should not be considered a production-ready module. However, I have made efforts to introduce no novel bugs. Please raise issues as they are found.

## Notes

Because the API does not currently implement parent object IDs in responses (e.g. client ID, device ID) they are added by the module. Added:

| Property | Added to |
| `client_id` | Devices, Jobs,

Additionally for ease of use an 'objectschema' property is added to each response object. See functions list below for a list of object schema IDs.

**This is limited in capability**. For example if you get a device by ID, client_id will be empty in the returned object.

Jobs don't have a mock object, so it's unclear what properties are returned.
The OpenAPI definition for job history is also clearly erroneous

## TODO / Features wanted

1. [X] Devices do not carry client ID in the object, making them hard to pipe *Currently implemented by the module, not the API*
2. [ ] Consider custom objects / classes
3. [ ] Testing with Pester

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

| Function             | Endpoint                                                      | Schema        | Notes |
| -------------------- | ------------------------------------------------------------- | ------------- | ----- |
| Get-BackupJob        | `/client/{client_id}/device/{device_id}/job`                  | `job`         |       |
| Get-BackupJob        | `/client/{client_id}/device/{device_id}/job/{job_id}`         | `job`         |       |
| Get-BackupJobHistory | `/client/{client_id}/device/{device_id}/job/{job_id}/history` | `job.history` |       |
