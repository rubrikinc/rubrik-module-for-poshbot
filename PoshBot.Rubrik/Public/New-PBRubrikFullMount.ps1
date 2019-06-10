function New-PBRubrikFullMount {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_fullmount',
        Aliases = 'fullmount'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [int]$Snapshot,
        [ValidateSet('vm')]
        [string]$Type,
        [string]$Id,
        [switch]$RDPFile
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

    if ($RDPFile) {
        ' '*1.5KB > "$home\$vm.rdp"
        New-PoshBotFileUpload -Path "$home\$vm.rdp" -Title "$vm.rdp"
    }
}
