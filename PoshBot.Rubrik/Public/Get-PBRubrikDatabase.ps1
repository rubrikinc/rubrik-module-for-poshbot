function Get-PBRubrikDatabase {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_database'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,

        [string]$Name,

        [string]$SLA,

        [string]$Instance,

        [string]$Hostname,

        [string]$ServerInstance,

        [string]$PrimaryClusterId,

        [string]$Id,

        [string]$SLAID,

        [switch]$Relic
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $dbParams = $PSBoundParameters | Select-Object -ExcludeProperty Connection
    if (-not $dbParams) {
        $dbParams = @{}
    }
    $dbs = Get-RubrikDatabase @dbParams

    if ($dbs.total -eq 0 -or -not $dbs) {
        $msg = 'No databases found'
    } else {
        $msg = ($dbs | Format-List | Out-String -Width 120)
    }

    New-PoshBotTextResponse -Text $msg -AsCode
}
