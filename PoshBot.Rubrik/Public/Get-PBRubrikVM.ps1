function Get-PBRubrikVM {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_vm',
        Aliases = 'vm'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [string]$Name,
        [string]$SLA,
        [switch]$Relic,
        [switch]$DetailedObject,
        [string]$PrimaryClusterId,
        [string]$Id
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    $objects = Get-RubrikVM @params | Select-Object -Property name,id,effectiveSlaDomainName,slaAssignment,clusterName,ipAddress

    if ($objects.count -eq 0 -or -not $objects) {
        $msg = 'No virtual machines found'
    } else {
        $msg = ($objects | Format-List | Out-String -Width 120)
    }

    New-PoshBotTextResponse -Text $msg -AsCode
}
