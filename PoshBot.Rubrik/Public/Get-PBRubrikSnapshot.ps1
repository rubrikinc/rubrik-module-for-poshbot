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

    $ResponseSplat = @{
        Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    New-PoshBotTextResponse @ResponseSplat
}
