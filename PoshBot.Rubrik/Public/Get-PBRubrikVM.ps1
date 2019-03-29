function Get-PBRubrikVM {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_vm'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,
        [string]$Name,
        [string]$SLA
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $vm = Get-RubrikVM -Name $Name -SLA $SLA
    if ($Name) {
        $vm = Get-RubrikVM -Name $Name
    } elseif ($SLA) {
        $vm = Get-RubrikVM -SLA $SLA
    }

    New-PoshBotTextResponse -Text ($vm | Format-List | Out-String -Width 120) -AsCode
}
