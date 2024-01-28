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
$ReleasePath = Join-Path -Path $BuildPath -ChildPath $ModuleName -AdditionalChildPath $ModuleVersion

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

task Docs {
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

task Build -Jobs Clean, Publish, Docs, Package

task Test -Jobs Publish, RunPesterTests

task . Build
