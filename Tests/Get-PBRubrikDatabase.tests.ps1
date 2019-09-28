Remove-Module -Name 'PoshBot.Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './PoshBot.Rubrik/PoshBot.Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './PoshBot.Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Public/Get-PBRubrikDatabase' -Tag 'Public', 'Get-PBRubrikDatabase' -Fixture {
#region Specific formatting
$Connection = @{
    Server   = '1.1.1.1'
    Username = 'RoxieAtRubrik'
    Password = 'KnowItAll'
}

$VerifyDB = @'
Name                   : RoxieAtRubrik
id                     : ID
effectiveSlaDomainName : ESDN
instanceName           : Almost right!
state                  : Floating
'@
#endregion

    Context -Name 'Parameter/GetDB' {
        function Clear-WhiteSpace ($Text) {
            "$($Text -replace "(`t|`n|`r)"," " -replace "\s+"," ")".Trim()
        }
        
        Mock -CommandName Connect-Rubrik -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {}
        Mock -CommandName Get-RubrikDatabase -Verifiable -ModuleName 'PoshBot.Rubrik' -MockWith {
            [pscustomobject]@{
                Name = 'RoxieAtRubrik'
                id = 'ID'
                effectiveSlaDomainName = 'ESDN'
                instanceName = 'Almost right!'
                state = 'Floating'
            }
        }

        It -Name 'Run without any parameters' -Test {
            Clear-WhiteSpace -Text (Get-PBRubrikDatabase -Connection $Connection).Text |
                Should -BeExactly (Clear-WhiteSpace -Text $VerifyDB)
        }

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Connect-Rubrik -ModuleName 'PoshBot.Rubrik' -Times 1
        Assert-MockCalled -CommandName Get-RubrikDatabase -ModuleName 'PoshBot.Rubrik' -Times 1
    }
}
