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
        $VmName = $objects.name
        $RdpPath = Join-Path -Path [io.path]::GetTempPath() -ChildPath "$VmName.rdp"

        New-RdpFile -Path $RdpPath -Full_Address $objects.name

        New-PoshBotFileUpload -Path $RdpPath -Title "$VmName.rdp"
    }
}
