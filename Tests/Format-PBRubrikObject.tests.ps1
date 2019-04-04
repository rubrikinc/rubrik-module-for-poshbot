Remove-Module -Name 'PoshBot.Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './PoshBot.Rubrik/PoshBot.Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './PoshBot.Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Private/Format-PBRubrikObject' -Tag 'Private', 'Format-PBRubrikObject' -Fixture {
#region Specific formatting
$UnformattedObject = [pscustomobject]@{
    id        = 'MOUNT_SNAPSHOT_aaa:::0'
    status    = 'QUEUED'
    progress  = '0'
    startTime = '29-Mar-19 9:24:01 PM'
    links     = '{@{href=https://192.168.11.121/api/v1/vmware/vm/request/MOUNT_SNAPSHOT_aaa:::0; rel=self}}'
}
#endregion

    Context -Name 'Existing Function, no objects' {
        It -Name 'Called from Get-PBRubrikVM, empty string' -Test {
            Format-PBRubrikObject -Object '' -FunctionName 'Get-PBRubrikVM' |
                Should -BeExactly 'No virtual machines found'
        }
        It -Name 'Called from Get-PBRubrikSLA, empty array' -Test {
            Format-PBRubrikObject -Object @() -FunctionName 'Get-PBRubrikSLA' |
                Should -BeExactly 'No SLAs found'
        }
        It -Name 'Called from Get-PBRubrikVM as null' -Test {
            Format-PBRubrikObject -Object $null -FunctionName 'Get-PBRubrikVM' |
                Should -BeExactly 'No virtual machines found'
        }
    }
    Context -Name 'Empty or incorrect Function, no objects' {
        It -Name 'Called from Get-PBSomeObject, empty string' -Test {
            Format-PBRubrikObject -Object '' -FunctionName 'Get-PBRubrikVM' |
                Should -BeExactly 'No virtual machines found'
        }
        It -Name 'Called from Get-PBSomeObject as null, should fail' -Test {
            Format-PBRubrikObject -Object $null -FunctionName 'Get-PBRubrikSLA' |
                Should -BeExactly 'No SLAs found'
        }
    }
    Context -Name 'Verify correct formatting' {
        It -Name 'Called without function, should ouput a string' -Test {
            Format-PBRubrikObject -Object $UnformattedObject -FunctionName 'Get-PBRubrikVM' |
                Should -BeOfType [System.String]
        }
    }
}
