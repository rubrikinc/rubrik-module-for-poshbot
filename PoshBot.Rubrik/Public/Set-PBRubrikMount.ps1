function Set-PBRubrikMount {
    [PoshBot.BotCommand(
        CommandName = 'rubrik_mount',
        Aliases = 'mount'
    )]
    [CmdletBinding(DefaultParameterSetName = 'Get')]
    param(
        [PoshBot.FromConfig()]
        [parameter(Mandatory)]
        [Parameter(ParameterSetName='Get')]
        [Parameter(ParameterSetName='Create')]
        [Parameter(ParameterSetName='Remove')]
        [hashtable]$Connection,
        [Parameter(ParameterSetName='Get')]
        [Parameter(ParameterSetName='Create')]
        [Parameter(ParameterSetName='Remove')]
        [string]$Id,
        [Parameter(ParameterSetName='Create')]
        [string]$MountName,
        [Parameter(ParameterSetName='Create')]
        [switch]$Create,
        [Parameter(ParameterSetName='Remove')]
        [switch]$Remove,
        [Parameter(ParameterSetName='Create')]
        [switch]$PowerOn
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $conn = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    # Create a new Live Mount
    # Required params = Id
    # Optional params = Name, PowerOn
    if ($id -ne $null -and $Create.IsPresent) {
        $params.Remove('Create') | Out-Null
        $msg = (New-RubrikMount @params -Confirm:$false | Format-List | Out-String -Width 120)
    }

    # Remove a Live Mount
    # Required params = Id, Force
    elseif ($id -ne $null -and $Remove.IsPresent) {
        $params.Remove('Remove') | Out-Null
        $msg = (Remove-RubrikMount @params -Force -Confirm:$false | Format-List | Out-String -Width 120)
    }

    else {
    # Get Live Mounts
    # Required params = n/a
        $objects = Get-RubrikMount @params

        if ($objects.count -eq 0 -or -not $objects) {
            $msg = 'No Live Mounts found'
        } else {
            $msg = ($objects | Format-List | Out-String -Width 120)
        }
    }

    New-PoshBotTextResponse -Text $msg -AsCode
}
