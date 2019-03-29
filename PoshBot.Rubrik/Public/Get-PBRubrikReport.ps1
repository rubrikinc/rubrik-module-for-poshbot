function Get-PBRubrikReport {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_report',
        Aliases = 'report'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [string]$Name,
        [ValidateSet('Canned', 'Custom')]
        [string]$Type,
        [string]$Id
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    $objects = Get-RubrikReport @params

    if ($objects.count -eq 0 -or -not $objects) {
        $msg = 'No reports found'
    } else {
        $msg = ($objects | Format-List | Out-String -Width 120)
    }

    New-PoshBotTextResponse -Text $msg -AsCode
}
