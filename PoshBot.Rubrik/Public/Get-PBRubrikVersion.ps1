
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
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $version = Get-RubrikVersion | Format-List | Out-String -Width 120
    New-PoshBotTextResponse -Text $version -AsCode
}
