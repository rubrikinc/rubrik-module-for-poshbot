Remove-Module -Name 'PoshBot.Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './PoshBot.Rubrik/PoshBot.Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './PoshBot.Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Public/Set-PBRubrikMount' -Tag 'Public', 'Set-PBRubrikMount' -Fixture {
#region Specific formatting
$Connection = @{
    Server   = '1.1.1.1'
    Username = 'RoxieAtRubrik'
    Password = 'KnowItAll'
}

$VerifyMount = 'MockMountName   : RoxieAtRubrik
MockMountdetail : Almost right!'
#endregion

    Context -Name 'Parameter/CreateMount' {
        Mock -CommandName Connect-Rubrik -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {}
        Mock -CommandName New-RubrikMount -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                MockMountName = 'RoxieAtRubrik'
                MockMountdetail = 'Almost right!'
            }
        }

        It -Name '-Id and -Create should create Livemount' -Test {
            (Set-PBRubrikMount -Id '1-1-1-1' -Create -Connection $Connection).Text |
                Should -BeExactly $VerifyMount
        }

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Connect-Rubrik -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName New-RubrikMount -ModuleName 'PoshBot.Rubrik' -Times 1
    }

    Context -Name 'Parameter/RemoveMount' {
        Mock -CommandName Connect-Rubrik -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {}
        Mock -CommandName Remove-RubrikMount -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                MockMountName = 'RoxieAtRubrik'
                MockMountdetail = 'Almost right!'
            }
        }

        It -Name '-Id and -Remove should remove Livemount' -Test {
            (Set-PBRubrikMount -Id '1-1-1-1' -Remove -Connection $Connection).Text |
                Should -BeExactly $VerifyMount
        }

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Connect-Rubrik -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName Remove-RubrikMount -ModuleName 'PoshBot.Rubrik' -Times 1
    }

    Context -Name 'Parameter/GetMount' {
        Mock -CommandName Connect-Rubrik -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {}
        Mock -CommandName Get-RubrikMount -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                MockMountName = 'RoxieAtRubrik'
                MockMountdetail = 'Almost right!'
            }
        }

        It -Name 'No parameters' -Test {
            (Set-PBRubrikMount -Connection $Connection).Text |
                Should -BeExactly $VerifyMount
        }

        It -Name 'Id parameter' -Test {
            (Set-PBRubrikMount -Id '1-1-1-1' -Connection $Connection).Text |
                Should -BeExactly $VerifyMount
        }

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Connect-Rubrik -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName Get-RubrikMount -ModuleName 'PoshBot.Rubrik' -Times 1
    }
}
