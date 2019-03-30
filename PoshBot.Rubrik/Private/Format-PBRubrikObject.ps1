function Format-PBRubrikObject {
    param (
        # The objects returned by the API, will be reformatted
        [Parameter(
            Position = 0,
            Mandatory = $true)]
        $Object,
        # Name of the function that calls this function, will be used to create custom message if no objects are returned
        [Parameter(
            Position = 1)]
        [string] $FunctionName
    )

    if (($object.count -eq 0) -or (-not $object)) {
        $msg = 'No virtual machines found'
    } else {
        $msg = ($objects | Format-List | Out-String -Width 120)
    }

    return $msg
}
