Remove-Module -Name 'PoshBot.Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './PoshBot.Rubrik/PoshBot.Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './PoshBot.Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Public/New-PBRubrikFullMount' -Tag 'Public', 'New-PBRubrikFullMount' -Fixture {
#region Specific formatting
$Connection = @{
    Server   = '1.1.1.1'
    Username = 'RoxieAtRubrik'
    Password = 'KnowItAll'
}
#endregion

    Context -Name 'Parameter/NewFullMount' {
        Mock -CommandName Connect-Rubrik -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {}
        Mock -CommandName Get-RubrikVM -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                id = '1-1-1-1'
            }
        }
        Mock -CommandName Get-RubrikSnapshot -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                id = '2-2-2-2'
            }
        }
        Mock -CommandName New-RubrikMount -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                id = '3-3-3-3'
            }
        }

        It -Name 'Run with basic parameters' -Test {
            (New-PBRubrikFullMount -id '1-1-1-1' -type 'vm' -snapshot 0 -Connection $Connection).Text |
                Should -Be 'id : 3-3-3-3'
        }

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Connect-Rubrik -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName Get-RubrikVM -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName Get-RubrikSnapshot -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName New-RubrikMount -ModuleName 'PoshBot.Rubrik' -Times 1
    }
}
