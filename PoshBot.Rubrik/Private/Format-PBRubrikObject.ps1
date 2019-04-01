function Format-PBRubrikObject {
<#
.SYNOPSIS
Unified function to format output to be used by the public functions

.DESCRIPTION
Format the output as strings and with a set width, will display different objects based on the function that called it

.NOTES
Written by Jaap Brasser for community usage
Twitter: @jaap_brasser
GitHub: jaapbrasser

.EXAMPLE
Format-PBRubrikObject -Object $objects -FunctionName $MyInvocation.MyCommand.Name

Description
-----------
When called from another Rubrik Module for PoshBot function, the function name will be used to determine the type of objects is contained in the $objects variable
#>
    param (
        # The objects returned by the API, will be reformatted
        [Parameter(
            Position = 0)]
        $Object,
        # Name of the function that calls this function, will be used to create custom message if no objects are returned
        [Parameter(
            Position = 1)]
        [string] $FunctionName
    )

    if (($object.count -eq 0) -or (-not $object)) {
        $msg = 'No {0} found'
        switch ($functionname) {
            'Get-PBRubrikDatabase' {$msg -f 'databases'}
            'Get-PBRubrikReport' {$msg -f 'reports'}
            'Get-PBRubrikSLA' {$msg -f 'SLAs'}
            'Get-PBRubrikSnapshot' {$msg -f 'Snapshots'}
            'Get-PBRubrikVersion' {$msg -f 'version information'}
            'Get-PBRubrikVM' {$msg -f 'virtual machines'}
            default {$msg -f 'objects'}
        }
    } else {
        $object | Format-List | Out-String -Width 120
    }
}
