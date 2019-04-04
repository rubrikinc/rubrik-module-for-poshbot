Remove-Module -Name 'PoshBot.Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './PoshBot.Rubrik/PoshBot.Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './PoshBot.Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Public/Get-PBRubrikSnapshot' -Tag 'Public', 'Get-PBRubrikSnapshot' -Fixture {
#region Specific formatting
$Connection = @{
    Server   = '1.1.1.1'
    Username = 'RoxieAtRubrik'
    Password = 'KnowItAll'
}

$VerifyDB = @'
id         : RoxieAtRubrik
vmName     : VM
date       : Today
cloudState : Almost right!
slaName    : Floating
'@
#endregion

    Context -Name 'Parameter/GetSnapshot' {
        Mock -CommandName Connect-Rubrik -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {}
        Mock -CommandName Get-RubrikSnapshot -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                id = 'RoxieAtRubrik'
                vmName = 'VM'
                date = 'Today'
                cloudState = 'Almost right!'
                slaName = 'Floating'
            }
        }

        It -Name 'Run with -id parameter' -Test {
            (Get-PBRubrikSnapshot -id '1-1-1-1' -Connection $Connection).Text |
                Should -BeExactly $VerifyDB
        }

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Connect-Rubrik -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName Get-RubrikSnapshot -ModuleName 'PoshBot.Rubrik' -Times 1
    }
}
