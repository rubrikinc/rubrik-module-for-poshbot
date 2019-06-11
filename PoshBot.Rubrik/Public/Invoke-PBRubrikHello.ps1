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

    if ($Language -eq 'Chinese') {
        $ResponseSplat = @{
            Text = '你好，我是罗茜！今天我将正式运行为PoshBot搭建的Rubrik模块 1.0.0.0 版本！'
        }
        New-PoshBotTextResponse @ResponseSplat

        Start-Sleep -Seconds 1

        $ResponseSplat = @{
            Text = '我拥有10个可供选择的Rubrik命令，你可以通过向我提问来了解它们
```
roxie gp poshbot.rubrik
```
'
        }
    } else {
        $ResponseSplat = @{
            Text = 'Hello, I am Roxie! Today I am on running version 1.0.0.0 of the Rubrik Module for PoshBot!'
        }
        New-PoshBotTextResponse @ResponseSplat

        Start-Sleep -Seconds 1

        $ResponseSplat = @{
            Text = 'I have 10 Rubrik commands available, you can view the available commands by asking me for help
```
roxie gp poshbot.rubrik
```
'
        }
        New-PoshBotTextResponse @ResponseSplat

        Start-Sleep -Seconds 1

        $ResponseSplat = @{
            Text = 'If you would like to change the language please say:
```
roxie hello -language <your prefered language>
```
'
        }
        New-PoshBotTextResponse @ResponseSplat
    }
}
