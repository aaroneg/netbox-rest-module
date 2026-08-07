# Changelog

## 1.0.0-beta

* Add some opinionated convenience functions to save configuration for Netbox to disk, and also to manage the credential in a slightly better way than writing it unencrypted to disk. You don't have to use them, but if you don't you have to handle more things yourself.
  * Set-NBCredential
  * Get-NBCredential
  * New-NBConnectionFromSecretVault
  * Write-NBConfig
  * Read-NBConfig

The *-NBConfig commands expect to be given a folder path to save the config file to, which will be saved as `nbconfig.xml`, the file name is not user-configurable. The Write-NBConfig command is expected to be run interactively as part of an environment setup. Read-NBConfig is meant to be used as a part of a script run, say for a scheduled task run.

The *-NBCredential and New-NBConnectionFromSecretVault commands are similar. They are opinionated in that they will set up and use the `Microsoft.PowerShell.SecretManagement` module to store passwords in a reusable way without writing passwords to disk in plain text. Naturally as soon as I do that, they 'archive' the project [Issue 247](https://github.com/PowerShell/SecretManagement/issues/247), saying that they're committed to fixing security problems. This was a stupid decision, because as much as Microsoft might want to believe that passwords (like api keys) are on their way out, that just isn't realistic any time soon -  and managing passwords without just leaving them in a plaintext file called "passwords.txt" is still a legitimate need. Not everyone's company is willing to spend money on a more complete credential management solution. I will keep looking around for a supported replacement.

## 1.0.0-alpha

* This release targets changes from Netbox 4.6
* implemented (and mandated) Netbox v2 keys, rating the major version bump
* implement GET authentication-check Get-NBAuthenticationCheck
* Netbox has made pretty major changes, and this release attempts to track them.
  * "Owner" field added to a large amount of fields
  * Some objects now support connections to multiple field types, so the behavior change is breaking.

## 0.0.9 and 0.0.10

Bugfix release, some minor improvements

## 0.0.8

This BIG release includes some code to make custom fields work, expands tags support, and implements a number of new endpoints. given the size of the changes, you may want to re-validate your scripts against your dev netbox instance.

* Many updates to the validation sets which power tab-completion
* Get-NBGenericItemByID, Get-NBGenericItemByName, and Get-NBGenericItems are added for when you have the API path, need to get one or more objects, and this module doesn't have a customized command yet for that endpoint. Should make it easier to get by while you open an issue or a PR and work proceeds to implement it.
* `Get-NBGenericItemsForParentItemByField` lets you pretty much ask for whatever you want. Example: `Get-NBGenericItemsForParentItemByField -Path 'dcim/device-bay-templates' -Field device_type_id -value 7|ft`. You can use the API docs for the `GET` method of whatever endpoint you like. `Get-NBGenericItemsForParentItemByField -Path 'dcim/device-bay-templates' -Field description__empty -value $true`. It should be very flexible if there's no more convenient cmdlet.
* New-NBGenericObject will allow you to take an object, change a few properties, then post it back as a new object. It will automatically try to replace object fields that are hashtables that contain an `id` field to just the ID number to make the API happy. It will do the same for status fields, but it's not heavily tested - YMMV. It's only tested on new devices at the moment. You will have to make sure your changes meet the requirements of the API, but the error message will be passed directly through. More information below the list of changes.
* `Set-NBGenericObject` will try to pass your changed object back to Netbox.
* Several other new cmdlet sets introduced - didn't write them all down.
* Bugfixes on New-NBDevice and Set-NBDevice
* There's a bunch more and I'm tired of typing. Just poke around.
* Some items just don't make a lot of sense to me to support - either they're very new, very annoying, or I don't have any use for them yet.

Try something like:

```powershell
$deviceObj=Get-NBGenericItemByName 'dcim/devices' 'Example1'
$deviceObj.name = 'Example2'
New-NBGenericObject -Path 'dcim/devices' -NewItem  $deviceObj
```

```powershell
$deviceObj=Get-NBGenericItemByName 'dcim/devices' 'Example1'
$deviceObj.comments = 'test comment'
Set-NBGenericObject -Path 'dcim/devices' -InputObject $deviceObj
```

## 0.0.7

This release clarifies that the only versions of powershell supported are the 'core' or cross-platfrom versions, not Windows Powershell 5.x, and applies changes introduced in Netbox's 4.1 API

* The module's metadata now clearly specifies that it only supports the Core edition (Powershell 7+, not Windows Powershell/5.x). For a long time, it's only been built and tested with 7, but I actually tested it with 5 and it doesn't work, and trying to put in some branching logic to do things differently on 5 was an incredibly frustrating experience. If having 5.x support is important to you and you have some experience with backporting code to 5.x, I'm willing to pick it up again if you're willing to provide some code.
* Fixed really dumb bug in set-nbdevice that prevented setting a primary IP address.
* Added @SebastianClaesson 's function to create a Get-NBPrefixAvailablePrefixes cmdlet.

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
