Remove-Module -Name 'PoshBot.Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './PoshBot.Rubrik/PoshBot.Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './PoshBot.Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Public/Get-PBRubrikVM' -Tag 'Public', 'Get-PBRubrikVM' -Fixture {
#region Specific formatting
$Connection = @{
    Server   = '1.1.1.1'
    Username = 'RoxieAtRubrik'
    Password = 'KnowItAll'
}

$VerifyDB = @'
name                   : RoxieAtRubrik
id                     : 1-1-1-1
effectiveSlaDomainName : VM
slaAssignment          : Today
clusterName            : Almost right!
ipAddress              : 127.0.0.1
'@
#endregion

    Context -Name 'Parameter/GetVM' {
        function Clear-WhiteSpace ($Text) {
            "$($Text -replace "(`t|`n|`r)"," " -replace "\s+"," ")".Trim()
        }
        
        Mock -CommandName Connect-Rubrik -Verifiable -ModuleName 'Poshbot.Rubrik' -MockWith {}
        Mock -CommandName Get-RubrikVM -Verifiable -ModuleName 'Poshbot.Rubrik' -MockWith {
            [pscustomobject]@{
                name = 'RoxieAtRubrik'
                id = '1-1-1-1'
                effectiveSlaDomainName = 'VM'
                slaAssignment = 'Today'
                clusterName = 'Almost right!'
                ipAddress = '127.0.0.1'
            }
        }

        It -Name 'Run without any parameters' -Test {
            Clear-WhiteSpace -Text (Get-PBRubrikVM -Connection $Connection).Text |
                Should -BeExactly (Clear-WhiteSpace -Text $VerifyDB)
        }
        Assert-VerifiableMock
        Assert-MockCalled -CommandName Connect-Rubrik -ModuleName 'Poshbot.Rubrik' -Exactly 1
        Assert-MockCalled -CommandName Get-RubrikVM -ModuleName 'Poshbot.Rubrik' -Exactly 1
    }
}
