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
        [Parameter(
            ParameterSetName='Create',
            Mandatory)]
        [Parameter(
            ParameterSetName='Remove')]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
        [Parameter(ParameterSetName='Create')]
        [string]$MountName,
        [Parameter(
            ParameterSetName='Create',
            Mandatory)]
        [switch]$Create,
        [Parameter(
            ParameterSetName='Remove',
            Mandatory)]
        [switch]$Remove,
        [Parameter(
            ParameterSetName='Remove')]
        [switch]$All,
        [Parameter(ParameterSetName='Create')]
        [switch]$PowerOn
    )

    $creds = [pscredential]::new($Connection.Username, ($Connection.Password | ConvertTo-SecureString -AsPlainText -Force))
    $null = Connect-Rubrik -Server $Connection.Server -Credential $creds

    $params = $PSBoundParameters
    $params.Remove('Connection') | Out-Null

    # Create a new Live Mount
    # Required params = Id
    # Optional params = Name, PowerOn
    if ($Create.IsPresent) {
        $params.Remove('Create') | Out-Null
        $objects = New-RubrikMount @params -Confirm:$false
        $ResponseSplat = @{
            Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
            AsCode = $true
        }
    }

    # Remove a Live Mount
    # Required params = Id, Force
    elseif ($Remove.IsPresent) {
        $params.Remove('Remove') | Out-Null
        if ($All.IsPresent) {
            $objects = Get-RubrikMount | Remove-RubrikMount -Force -Confirm:$false
        }
        else {
            $objects = Remove-RubrikMount @params -Force -Confirm:$false
        }
        $ResponseSplat = @{
            Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
            AsCode = $true
        }
    }

    else {
    # Get Live Mounts
    # Required params = n/a
        $objects = Get-RubrikMount @params

        $ResponseSplat = @{
            Text = Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name
            AsCode = $true
        }
    }

    New-PoshBotTextResponse @ResponseSplat
}
