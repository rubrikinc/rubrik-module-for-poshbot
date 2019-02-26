function Get-PBRubrikReport {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_report'
    )]
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [hashtable]$Connection,

        [string]$Name,

        [ValidateSet('Canned', 'Custom')]
        [string]$Type,

        [string]$Id
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters | Select-Object -ExcludeProperty Connection
    if (-not $params) {
        $params = @{}
    }
    $reports = Get-RubrikReport @params

    if ($reports.total -eq 0 -or -not $reports) {
        $msg = 'No reports found'
    } else {
        $msg = ($reports | Format-List | Out-String -Width 120)
    }

    New-PoshBotTextResponse -Text $msg -AsCode
}
