function Restore-PBRubrikFile.ps1 {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_restorefile',
        Aliases = 'restorefile'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [string]$VM,
        [string]$FileName,
        [string]$Id
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    switch ($type) {
        'vm' {$objects = (Get-RubrikVM -id $Id | Get-RubrikSnapshot)[$Snapshot] | New-RubrikMount -PowerOn -Confirm:$false}
    }

    $ResponseSplat = @{
        Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    New-PoshBotTextResponse @ResponseSplat
}