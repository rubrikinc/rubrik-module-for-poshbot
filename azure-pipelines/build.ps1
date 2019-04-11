[CmdletBinding()]
param(
    #
    [switch] $Bootstrap,
    # Run Pester and export results of Pester tests
    [switch] $Test,
    # Will initiate building of the PowerShell module
    [switch] $Build
)

# Bootstrap step
if ($Bootstrap.IsPresent) {
    Write-Information "Validate and install missing prerequisits for building ..."

    # For testing Pester
    if (-not (Get-Module -Name Pester -ListAvailable) -or (Get-Module -Name Pester -ListAvailable)[0].Version -eq [Version]'3.4.0') {
        Write-Warning "Module 'Pester' is missing. Installing 'Pester' ..."
        Install-Module -Name Pester -Scope CurrentUser -Force
    }

    # Additional required modules
    'Rubrik', 'PoshBot', 'PSCodeCovIo' | ForEach-Object {
        if (-not (Get-Module -Name $_ -ListAvailable)) {
            Write-Warning "Module '$_' is missing. Installing '$_' ..."
            Install-Module -Name $_ -Scope CurrentUser -Force
        }
    }
}

# Build step
if ($Build.IsPresent) {
    # Build process to be created
}

# Test step
if($Test.IsPresent) {
    if (-not (Get-Module -Name Pester -ListAvailable)) {
        throw "Cannot find the 'Pester' module. Please specify '-Bootstrap' to install build dependencies."
    }

    if (-not (Get-Module -Name PSCodeCovIo -ListAvailable)) {
        throw "Cannot find the 'PSCodeCovIo' module. Please specify '-Bootstrap' to install build dependencies."
    }

    $RelevantFiles = (Get-ChildItem ./PoshBot.Rubrik -Recurse -Include "*.psm1","*.ps1").FullName

    if ($env:TF_BUILD) {
        $res = Invoke-Pester "./Tests" -OutputFormat NUnitXml -OutputFile TestResults.xml -CodeCoverage $RelevantFiles -PassThru
        if ($res.FailedCount -gt 0) { throw "$($res.FailedCount) tests failed." }
    } else {
        $res = Invoke-Pester "./Tests" -CodeCoverage $RelevantFiles -PassThru
    }

    Export-CodeCovIoJson -CodeCoverage $res.CodeCoverage -RepoRoot $pwd -Path coverage.json

    <#
    TODO include code coverage
    Invoke-WebRequest -Uri 'https://codecov.io/bash' -OutFile codecov.sh
    #>
}
