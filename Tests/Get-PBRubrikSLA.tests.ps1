Remove-Module -Name 'PoshBot.Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './PoshBot.Rubrik/PoshBot.Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './PoshBot.Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Public/Get-PBRubrikSLA' -Tag 'Public', 'Get-PBRubrikSLA' -Fixture {
#region Specific formatting
$Connection = @{
    Server   = '1.1.1.1'
    Username = 'RoxieAtRubrik'
    Password = 'KnowItAll'
}

$VerifySLA = @'
Name        : RoxieAtRubrik
id          : Almost right!
frequencies : {1, 2, 3}
'@ -replace "`r"
#endregion

    Context -Name 'Parameter/GetSLA' {
        Mock -CommandName Connect-Rubrik -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {}
        Mock -CommandName Get-RubrikSLA -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                Name = 'RoxieAtRubrik'
                id = 'Almost right!'
                frequencies = 1,2,3
            }
        }

        It -Name 'Run without any parameters' -Test {
            (Get-PBRubrikSLA -Connection $Connection).Text |
                Should -BeExactly $VerifySLA
        }

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Connect-Rubrik -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName Get-RubrikSLA -ModuleName 'PoshBot.Rubrik' -Times 1
    }
}
