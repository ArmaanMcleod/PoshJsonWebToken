[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateSet('Debug', 'Release')]
    [string]
    $Configuration = 'Debug',

    [Parameter(Mandatory = $false)]
    [ValidateSet('Build', 'Test', 'Docs')]
    [string]
    $Task = 'Build'
)

Import-Module "$PSScriptRoot/tools/helper.psm1" -Force

Write-Log "Validate and install missing prerequisites for building ..."

Install-Dotnet

$modulePath = Join-Path -Path $PSScriptRoot -ChildPath 'tools' -AdditionalChildPath 'Modules'

$requirements = Import-PowerShellDataFile -Path (Join-Path -Path $PSScriptRoot -ChildPath 'requirements-dev.psd1')

foreach ($req in $requirements.GetEnumerator()) {

    $targetPath = Join-Path -Path $modulePath -ChildPath $req.Key

    if (Test-Path -LiteralPath $targetPath) {
        Import-Module -Name $targetPath -Force -ErrorAction Stop
        continue
    }

    Write-Log "Installing build pre-req $($req.Key) as it is not installed"

    New-Item -Path $targetPath -ItemType Directory | Out-Null

    $webParams = @{
        Uri             = "https://www.powershellgallery.com/api/v2/package/$($req.Key)/$($req.Value)"
        OutFile         = Join-Path -Path $modulePath -ChildPath "$($req.Key).zip"
        UseBasicParsing = $true
    }

    Invoke-WebRequest @webParams
    Expand-Archive -Path $webParams.OutFile -DestinationPath $targetPath -Force
    Remove-Item -LiteralPath $webParams.OutFile -Force

    Import-Module -Name $targetPath -Force -ErrorAction Stop
}

$invokeBuildParams = @{
    Task          = @($Task)
    File          = Join-Path -Path $PSScriptRoot -ChildPath 'PoshJsonWebToken.build.ps1'
    Configuration = $Configuration
}

Invoke-Build @invokeBuildParams
