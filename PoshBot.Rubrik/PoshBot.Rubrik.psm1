'Private','Public' | ForEach-Object {
    [io.directory]::getfiles("$PSScriptRoot\$_") | ForEach-Object {
        $functioncontent = [io.file]::readalltext($_)
        $ExecutionContext.InvokeCommand.InvokeScript($functioncontent, $false, [Management.Automation.Runspaces.PipelineResultTypes]::None, $null, $null)
    }
}
