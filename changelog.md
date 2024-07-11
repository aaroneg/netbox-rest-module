# Changelog

## 0.0.6

This release mostly refines previous functionality, though there are some new bits.

* When using -verbose or -debug with any of these commands, the private functions that make the API call now generate more useful output - who called them, why, if the api rejects a call what was the reasoning it provided, and similar enhancements.
* New CMDLETS: Get-NBIPAddressForDeviceInterface and Get-NBIPAddressForVMInterface. These do pretty much what it sounds like they do - You no longer have to get all IP addresses and do the filtering within powershell, now the API does the filtering down to just what you want, which is more performance friendly for the powershell scripter and the server running Netbox.
* New-NBVM now uses powershell parametersets to make sure that you always supply the correct starting information since a vm has to either be tied to a site or a cluster before the API will accept it. Makes for nasty module code but save you time trying to understand the cryptic API response if you get it wrong.
* Bugfix in Set-NBVM - some fields in the validateset were wrong, causing those fields to never ever get updated.

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