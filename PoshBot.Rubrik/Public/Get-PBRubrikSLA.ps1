function Get-PBRubrikSLA {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_sla'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,

        [string]$Name
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    if ($Name) {
        $slas = Get-RubrikSLA -Name $Name
    } else {
        $slas = Get-RubrikSLA
    }
    New-PoshBotTextResponse -Text ($slas | Format-List | Out-String -Width 120) -AsCode
}
