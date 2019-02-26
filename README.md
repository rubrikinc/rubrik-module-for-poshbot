# PoshBot.Rubrik

## Overview

PoshBot.Rubrik is a [PoshBot](https://github.com/poshbotio/PoshBot) plugin for interacting with a [Rubrik](https://www.rubrik.com/) cluster.

## Installation

To install the plugin from within PoshBot, first make sure the PowerShell module is in a directory located in your `$env:PSModulePath`.

```
!install-plugin PoshBot.Rubrik
```

## Configuration

This plugin requires values for your username/password and Rubrik cluster connection information to be stored in the [Plugin Configuration](http://docs.poshbot.io/en/latest/guides/plugin-configuration/) section of your [bot configuration file](https://poshbot.readthedocs.io/en/latest/guides/configuration/).
Insert a new **hashtable** entry under `PluginConfiguration` called `PoshBot.Rubrik` with values for the Rubrik endpoint, username, and password.
This connection information will be supplied to the Rubrik commands at runtime.

#### MyPoshBotConfig.psd1

```powershell
@{
  # Other options ommitted for brevity

  PluginConfiguration = @{
    'PoshBot.Rubrik' = @{
      Server   = 'myrubrikcluster.mydomain.tld'
      Username = 'admin'
      Password = 'hunter2'
    }
  }
}
```

## Examples

```
!rubrik_version
```

```
!rubrik_sla
```

```
!rubrik_report
```

```
!rubrik_database
```
