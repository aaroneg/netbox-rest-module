# Changelog 

## 0.0.5

Target Netbox API version for 0.0.5 is `v4.0.6`.

This version aims to implement coverage of circuits and the other object types related to them. It also aims to implement support for tags.

* Added basic support for Tags (`/api/extras/tags`), full support for adding tags to objects will require some more thought
* Updated validation set for 'devices' to use 'role' instead of 'device_role' to address API breaking change in v4.
* Added Get-NBObjectTypes and Get-NBObjectTypeByID so the operator can see what objects Netbox supports in whatever version they're looking at, as long as it's new enough to support this API endpoint
* Add support for Circuits/Providers
* Add support for Circuits/ProviderAccounts
* Add support for Circuits/ProviderNetworks
* Add support for Circuits/CircuitTypes
* Add support for Circuits/Circuits
* Add support for Circuits/CircuitTerminations
* Expand IPAM/Services coverage
* Add support for IPAM/ServiceTemplates
* Add support for DCIM/PowerPanels
* Add support for DCIM/PowerFeeds


## Previous versions

I didn't start keeping a changelog until 0.0.5. If you're that interested you'll need to dig through commits.