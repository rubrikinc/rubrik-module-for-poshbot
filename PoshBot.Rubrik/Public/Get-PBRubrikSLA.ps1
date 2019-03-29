function Get-PBRubrikSLA {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_sla'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [string]$Name,
        [string]$PrimaryClusterId,
        [string]$Id
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    $objects = Get-RubrikSLA @params | Select-Object -Property name,id,frequencies -ExpandProperty frequencies

    if ($objects.count -eq 0 -or -not $objects) {
        $msg = 'No SLAs found'
    } else {
        $msg = ($objects | Format-List | Out-String -Width 120)
    }

    New-PoshBotTextResponse -Text $msg -AsCode
}
