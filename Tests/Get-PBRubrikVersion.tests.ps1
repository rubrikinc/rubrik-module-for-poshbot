Remove-Module -Name 'PoshBot.Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './PoshBot.Rubrik/PoshBot.Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './PoshBot.Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Public/Get-PBRubrikVersion' -Tag 'Public', 'Get-PBRubrikVersion' -Fixture {
#region Specific formatting
$Connection = @{
    Server   = '1.1.1.1'
    Username = 'RoxieAtRubrik'
    Password = 'KnowItAll'
}

$VerifyReport = @'
Name   : RoxieAtRubrik
Detail : Almost right!
'@
#endregion

    Context -Name 'Parameter/GetVersion' {
        Mock -CommandName Connect-Rubrik -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {}
        Mock -CommandName Get-RubrikVersion -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                Name = 'RoxieAtRubrik'
                Detail = 'Almost right!'
            }
        }

        It -Name 'Run without any parameters' -Test {
            (Get-PBRubrikVersion -Connection $Connection).Text |
                Should -BeExactly $VerifyReport
        }

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Connect-Rubrik -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName Get-RubrikVersion -ModuleName 'PoshBot.Rubrik' -Times 1
    }
}
