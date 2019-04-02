
function Get-PBRubrikVersion {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_version',
        Aliases = 'version'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $objects = Get-RubrikVersion

    $ResponseSplat = @{
        Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    New-PoshBotTextResponse @ResponseSplat
}
