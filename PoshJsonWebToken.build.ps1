[CmdletBinding()]
param(
    [ValidateSet('Debug', 'Release')]
    [string]
    $Configuration = 'Debug'
)

$BuildPath = Join-Path -Path $PSScriptRoot -ChildPath 'out'
$SourcePath = Join-Path -Path $PSScriptRoot -ChildPath 'src'
$ModuleManifiestPath = Join-Path -Path $SourcePath -ChildPath 'PoshJsonWebToken.psd1'
$ModuleManifest = Test-ModuleManifest -Path $ModuleManifiestPath
$ModuleVersion = $ModuleManifest.Version
$ModuleName = (Get-Item -Path $ModuleManifiestPath).BaseName
$ModulePath = Join-Path -Path $BuildPath -ChildPath $ModuleName
$ReleasePath = Join-Path -Path $ModulePath -ChildPath $ModuleVersion
$ToolsPath = Join-Path -Path $PSScriptRoot -ChildPath 'tools'

task Clean {
    try {
        Push-Location -Path $SourcePath

        if (Test-Path -Path $ReleasePath -PathType Container) {
            Write-Log "Deleting $ReleasePath" -Warning
            Remove-Item -Path $ReleasePath -Recurse -Force
        }

        dotnet clean
    }
    finally {
        Pop-Location
    }
}

task Publish {
    try {
        Push-Location -Path $SourcePath
        Write-Log "Publishing $Configuration configuration to $ReleasePath"
        dotnet publish --output $ReleasePath --configuration $Configuration
    }
    finally {
        Pop-Location
    }
}

task ExternalHelp {
    $docsPath = Join-Path -Path $PSScriptRoot -ChildPath 'docs' -AdditionalChildPath 'en-US'
    $outputPath = Join-Path -Path $ReleasePath -ChildPath 'en-US'
    New-ExternalHelp -Path $docsPath -OutputPath $outputPath | Out-Null
}

task Package {
    $nupkgPath = Join-Path -Path $BuildPath -ChildPath "$ModuleName.$ModuleVersion.nupkg"
    if (Test-Path -Path $nupkgPath) {
        Remove-Item -Path $nupkgPath -Force
    }

    $repoParams = @{
        Name               = 'LocalRepo'
        SourceLocation     = $BuildPath
        PublishLocation    = $BuildPath
        InstallationPolicy = 'Trusted'
    }

    if (Get-PSRepository -Name $repoParams.Name -ErrorAction SilentlyContinue) {
        Unregister-PSRepository -Name $repoParams.Name
    }

    Register-PSRepository @repoParams

    try {
        Publish-Module -Path $ReleasePath -Repository $repoParams.Name
    }
    finally {
        Unregister-PSRepository -Name $repoParams.Name
    }
}

task RunPesterTests {
    $testScriptPaths = Join-Path -Path $PSScriptRoot -ChildPath 'test' -AdditionalChildPath '*.Tests.ps1'

    $testResultsPath = Join-Path -Path $BuildPath -ChildPath 'TestResults'
    if (-not(Test-Path -Path $testResultsPath)) {
        New-Item -Path $testResultsPath -ItemType Directory
    }

    $testResultsFile = Join-Path -Path $testResultsPath -ChildPath 'Pester.xml'
    if (Test-Path -Path $testResultsFile) {
        Remove-Item -Path $testResultsFile -Force
    }

    $configuration = [PesterConfiguration]::Default
    $configuration.Output.Verbosity = 'Detailed'
    $configuration.Run.Exit = $true
    $configuration.Run.Path = $testScriptPaths
    $configuration.TestResult.Enabled = $true
    $configuration.TestResult.OutputPath = $testResultsFile
    $configuration.TestResult.OutputFormat = 'NUnitXml'

    Invoke-Pester -Configuration $configuration
}

task MarkdownHelp {
    # Add ProgressAction parameter workaround for https://github.com/PowerShell/platyPS/issues/595
    $platyPSManifestPath = Join-Path -Path $ToolsPath -ChildPath 'Modules' -AdditionalChildPath 'platyPS', 'platyPS.psm1'
    $platPSManifestContent = Get-Content -Path $platyPSManifestPath
    $platPSManifestContent[2544] = "{0}`r`n{1}" -f "'ProgressAction',", $platPSManifestContent[2544]
    $platPSManifestContent | Set-Content -Path $platyPSManifestPath
    Import-Module $ModulePath -Force
    $docsPath = Join-Path -Path $PSScriptRoot -ChildPath 'docs' -AdditionalChildPath 'en-US'
    Update-MarkdownHelp -Path $docsPath
}

task Build -Jobs Clean, Publish, ExternalHelp, Package

task Test -Jobs Publish, RunPesterTests

task Docs -Jobs Publish, MarkdownHelp

task . Build
