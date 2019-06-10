function Invoke-PBRubrikHello {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_hello',
        Aliases = 'hello'
    )]
    [cmdletbinding()]
    param(
        [ValidateSet('English','Chinese')]
        [string] $Language
    )


    if ($Language) {

    } else {
        $ResponseSplat = @{
            Text = 'Hello, I am Roxie! Today I am on running version 1.0.0.0 of the Rubrik Module for PoshBot!'
        }
        New-PoshBotTextResponse @ResponseSplat

        Start-Sleep -Seconds 1

        $ResponseSplat = @{
            Text = 'I have 10 Rubrik commands available, you can view the available commands by asking me for help
```
roxie gp rubrik
```
'
        }
        New-PoshBotTextResponse @ResponseSplat

        Start-Sleep -Seconds 1

        $ResponseSplat = @{
            Text = 'If you would like to change the language please say:
```
roxie language <your prefered language>
```
'
        }
        New-PoshBotTextResponse @ResponseSplat
    }
}
