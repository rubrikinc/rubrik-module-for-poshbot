# Quick Start Guide

* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Configuration](#configuration)
    * [Sample Configuration](#sample-configuration)
* [Validation](#validation)

## Prerequisites

We're going to make the assumption that you have a fully operational copy of PoshBot running in your environment. If this isn't true, make sure to visit:

1. [PoshBot Project](https://github.com/poshbotio/PoshBot)
2. [PoshBot Documentation](https://poshbot.readthedocs.io/en/latest/)

## Installation

To start, make sure you have downloaded the module from this repository and placed it into your `$env:PSModulePath`. PoshBot will then be able to install the module using the command below:

```
!install-plugin PoshBot.Rubrik
```

## Configuration

This plugin requires values for your Rubrik cluster (server), username, and password information to be stored in the [Plugin Configuration](http://docs.poshbot.io/en/latest/guides/plugin-configuration/) section of your [bot configuration file](https://poshbot.readthedocs.io/en/latest/guides/configuration/). This ensures that your credentials are not being passed in clear text or required when using PoshBot.

To do this:

1. Locate your `PoshBotConfig.psd1` file that is being used to configure PoshBot.
1. Insert a new **hashtable** entry under `PluginConfiguration` called `PoshBot.Rubrik` with values for the Rubrik cluster (server), username, and password.

_Note: The `$Connection` information will be supplied to the Rubrik commands at runtime._

### Sample Configuration

Here is what you'll want to add to your `PoshBotConfig.psd1` file:

```powershell
  # Other options ommitted for brevity

  PluginConfiguration = @{
    'PoshBot.Rubrik' = @{
      Connection = @{
        Server   = 'rubrik.cluster.tld'
        Username = 'username'
        Password = 'password'
      }
    }
  }
```

Note: If you see this error, it means that you did not insert your connection information into the `PoshBotConfig.psd1` file:

```
Command Exception
CommandRequirementsNotMet: Mandatory parameters for [command] not provided.
Usage:
    syntaxitem
    ----------
    {@{name=rubrik_version; commonparameters=true; parameter=system.object[]}}
```

## Validation

Once completed, make sure that your PoshBot is able to respond to Rubrik requests by requesting the Rubrik cluster version.

```
!rubrik_version

id                  : 123456789-abcd-1234-abcd-1234567890
version             : 5.0.0
apiVersion          : 1
name                : Rubrik_cluster
timezone            : @{timezone=America/Los_Angeles}
geolocation         : @{address=Palo Alto, CA, USA}
acceptedEulaVersion : 1.0
latestEulaVersion   : 1.0
```

For more commands to run with this module, use `!help` to see a list of all available commands. All of the commands listed with the prefix `PoshBot.Rubrik:` are part of this module, such as what is shown below:

```
PoshBot.Rubrik:rubrik_database                                   Command 0.1.0
PoshBot.Rubrik:rubrik_report                                     Command 0.1.0
PoshBot.Rubrik:rubrik_sla                                        Command 0.1.0
PoshBot.Rubrik:rubrik_version                                    Command 0.1.0
```
