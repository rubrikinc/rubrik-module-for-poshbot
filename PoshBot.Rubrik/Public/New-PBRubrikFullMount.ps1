function New-PBRubrikFullMount {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_fullmount',
        Aliases = 'livemount'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [int]$Snapshot = 0,
        [ValidateSet('vm')]
        [string]$Type = 'vm',
        [string]$Id,
        [string]$Name,
        [switch]$RDPFile
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    switch ($type) {
        'vm' {
            $objects =
                if ($Id) {
                    $VM = Get-RubrikVM -Id $Id
                    ($VM | Get-RubrikSnapshot)[$Snapshot] | New-RubrikMount -PowerOn:$true -Confirm:$false
                } elseif ($Name) {
                    $VM = Get-RubrikVM -Name $Name
                    ($VM | Get-RubrikSnapshot)[$Snapshot] | New-RubrikMount -PowerOn:$true -Confirm:$false
                }
        }
    }

    $ResponseSplat = @{
        Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
        AsCode = $true
    }

    New-PoshBotTextResponse @ResponseSplat

    if ($RDPFile) {
        $VmName = "$id.rubrik.us"
        $RdpPath = Join-Path -Path ([io.path]::GetTempPath()) -ChildPath "$VmName.rdp"

        New-RdpFile -Path $RdpPath -Full_Address $vmname

        New-PoshBotFileUpload -Path $RdpPath -Title "$VmName.rdp"
    }
}
