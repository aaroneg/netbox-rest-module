# Netbox-Rest-Module

## Installing

`install-module netbox-rest-module`


## Scope

This module will not cover all endpoints in netbox, but I will accept PRs if you're willing to match the code style.

For example, it does not currently handle parent/child device relationships beyond being able to say that the device is a parent or child object, it will not create the relationship.

## Development patterns

`/Private` - a few helper functions to cut down on code repetition

`/Public/endpoints/*/*.ps1` - functions specific to each division and endpoint

Most functions to directly manipulate an item in netbox will use the functions defined in /Private/api-items.ps1.

## Usage

> This module is only tested with PowerShell 7 but it'll probably work with Windows Powershell

We offer a few basic commands for most objects:

* New-Thing : Has mandatory parameters based on what netbox requires as of Netbox 3.2.8, unless the parameter is nullable.
* Get-Things : No mandatory parameters
* Get-ThingByID : Requires the ID of the thing you're requesting
* Get-ThingByName : Requires the name of the thing you're requesting and is not case-sensitive
* Find-ThingsContainingName : Looks for all things containing the characters you specify.
* Set-Thing: Takes an object id, key, and value to set on the object in question
* Remove-Thing: Removes an object based on ID

You can get a full listing of currently supported commands using `get-command -module netbox-rest-module`.

If something isn't on the list that you need, and you're willing to put in the effort to make it work, I will happily accept PRs that match the existing style. Most of these .ps1 files are copy/pasteable with minor alterations for basic functionality - just find another endpoint that's similar and dive in.
