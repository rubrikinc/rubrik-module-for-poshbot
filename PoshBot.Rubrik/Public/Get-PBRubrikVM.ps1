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
        [string]$PrimaryClusterId = 'local',
        [string]$Id
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    $objects = Get-RubrikVM @params | Select-Object -Property name,id,effectiveSlaDomainName,slaAssignment,clusterName,ipAddress

    $ResponseSplat = @{
        Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    New-PoshBotTextResponse @ResponseSplat
}
