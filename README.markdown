Skip Apple Setup Assistant
==========================

This repository contains a script to build a package that when installed, on a system image or as part of an OS deployment workflow, disables Apple's first boot setup assistant. You can download a prebuilt, signed, flat package from the [releases page](//github.com/MagerValp/SkipAppleSetupAssistant/releases).

The package consists of two empty, hidden files, that when present in a system prevents the setup assistant from running:

* `/private/var/db/.AppleSetupDone`
* `/Library/Receipts/.SetupRegComplete` (only needed for old versions of OS X)

The package only contains a payload with these two files, there are no scripts or other moving parts.


What Isn't Skipped
------------------

This package skips the setup assistant, but users will still be prompted with the following dialogs when logging in:

Dialog              | How To Setup
------------------- | ------------
Diagnostics & Usage | [Rich Trouton's blog](https://derflounder.wordpress.com/2014/11/21/controlling-the-diagnostics-usage-report-settings-on-yosemite)
iCloud              | [Rich Trouton's blog](https://derflounder.wordpress.com/2014/10/16/disabling-the-icloud-and-diagnostics-pop-up-windows-in-yosemite/)


What You Have To Do
-------------------

The setup assistant configures several important apsects of the system. Instead you will have to configure the image or deployment workflow to perform these steps:

* Keyboard & Region
* Timezone
* Location Services
* Network setup
* Create first user, e.g with [CreateUserPkg](http://magervalp.github.io/CreateUserPkg/)

<!--
Step               | How To Setup
------------------ | ------------
Keyboard & Region  | 
Timezone           | 
Location Services  | 
Network setup      | 
Create first user  | [CreateUserPkg](http://magervalp.github.io/CreateUserPkg/)
-->