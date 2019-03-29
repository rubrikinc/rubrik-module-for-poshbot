function Get-PBRubrikSnapshot {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_snapshot',
        Aliases = 'snapshot'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [string]$Id,
        [int]$CloudState,
        [switch]$OnDemandSnapshot,
        [datetime]$Date,
        [int]$SnapshotQuantity = 3
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    $objects = Get-RubrikSnapshot @params | Select-Object -Property id,vmName,date,cloudState,slaName -First $SnapshotQuantity

    if ($objects.count -eq 0 -or -not $objects) {
        $msg = 'No snapshots found'
    } else {
        $msg = ($objects | Format-List | Out-String -Width 120)
    }

    New-PoshBotTextResponse -Text $msg -AsCode
}
