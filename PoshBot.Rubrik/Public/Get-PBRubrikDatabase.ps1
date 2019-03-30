function Get-PBRubrikDatabase {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_database',
        Aliases = ('database')
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

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    $objects = Get-RubrikDatabase @params | Select-Object -Property name,id,effectiveSlaDomainName,instanceName,state

    $ResponseSplat = @{
        Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    New-PoshBotTextResponse @ResponseSplat
}
