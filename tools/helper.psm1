
$MinimalSDKVersion = '6.0.100'
$IsWindowsEnv = [System.Environment]::OSVersion.Platform -eq "Win32NT"
$LocalDotnetDirPath = if ($IsWindowsEnv) { "$env:LocalAppData\Microsoft\dotnet" } else { "$env:HOME/.dotnet" }

<#
.SYNOPSIS
    Find the dotnet SDK that meets the minimal version requirement.
#>
function Find-Dotnet {
    $dotnetFile = if ($IsWindowsEnv) { "dotnet.exe" } else { "dotnet" }
    $dotnetExePath = Join-Path -Path $LocalDotnetDirPath -ChildPath $dotnetFile

    # If dotnet is already in the PATH, check to see if that version of dotnet can find the required SDK.
    # This is "typically" the globally installed dotnet.
    $foundDotnetWithRightVersion = $false
    $dotnetInPath = Get-Command 'dotnet' -ErrorAction Ignore
    if ($dotnetInPath) {
        $foundDotnetWithRightVersion = Test-DotnetSDK $dotnetInPath.Source
    }

    if (-not $foundDotnetWithRightVersion) {
        if (Test-DotnetSDK $dotnetExePath) {
            Write-Warning "Can't find the dotnet SDK version $MinimalSDKVersion or higher, prepending '$LocalDotnetDirPath' to PATH."
            $env:PATH = $LocalDotnetDirPath + [IO.Path]::PathSeparator + $env:PATH
        }
        else {
            throw "Cannot find the dotnet SDK with the version $MinimalSDKVersion or higher. Please specify '-Bootstrap' to install build dependencies."
        }
    }
}

<#
.SYNOPSIS
    Check if the dotnet SDK meets the minimal version requirement.
#>
function Test-DotnetSDK {
    param($dotnetExePath)

    if (Test-Path $dotnetExePath) {
        $installedVersion = & $dotnetExePath --version
        return $installedVersion -ge $MinimalSDKVersion
    }
    return $false
}

<#
.SYNOPSIS
    Install the dotnet SDK if we cannot find an existing one.
#>
function Install-Dotnet {
    [CmdletBinding()]
    param(
        [string]$Channel = 'release',
        [string]$Version = $MinimalSDKVersion
    )

    try {
        Find-Dotnet
        return  # Simply return if we find dotnet SDk with the correct version
    }
    catch { }

    $logMsg = if (Get-Command 'dotnet' -ErrorAction Ignore) {
        "dotnet SDK out of date. Require '$MinimalSDKVersion' but found '$dotnetSDKVersion'. Updating dotnet."
    }
    else {
        "dotent SDK is not present. Installing dotnet SDK."
    }
    Write-Log $logMsg -Warning

    $obtainUrl = "https://raw.githubusercontent.com/dotnet/cli/master/scripts/obtain"

    try {
        Remove-Item $LocalDotnetDirPath -Recurse -Force -ErrorAction Ignore
        $installScript = if ($IsWindowsEnv) { "dotnet-install.ps1" } else { "dotnet-install.sh" }
        Invoke-WebRequest -Uri $obtainUrl/$installScript -OutFile $installScript

        if ($IsWindowsEnv) {
            & .\$installScript -Channel $Channel -Version $Version
        }
        else {
            bash ./$installScript -c $Channel -v $Version
        }
    }
    finally {
        Remove-Item $installScript -Force -ErrorAction Ignore
    }
}

<#
.SYNOPSIS
    Write log message for the build.
#>
function Write-Log {
    param(
        [string] $Message,
        [switch] $Warning,
        [switch] $Indent
    )

    $foregroundColor = if ($Warning) { "Yellow" } else { "Green" }
    $indentPrefix = if ($Indent) { "    " } else { "" }
    Write-Host -ForegroundColor $foregroundColor "${indentPrefix}${Message}"
}

<#
.SYNOPSIS
    Expands Nupkg package contents by first converting to ZIP then expanding archive.
#>
function Expand-Nupkg {
    param (
        [string] $ModuleManfifestPath,
        [string] $OutputPath
    )

    $moduleManifest = Test-ModuleManifest -Path $ModuleManfifestPath
    $moduleVersion = $moduleManifest.Version
    $moduleName = (Get-Item -Path $ModuleManfifestPath).BaseName

    $destPath = Join-Path -Path $OutputPath -ChildPath $moduleName -AdditionalChildPath $moduleVersion
    if (-not(Test-Path -LiteralPath $destPath)) {
        New-Item -Path $destPath -ItemType Directory | Out-Null
    }

    $nupkgPath = Join-Path -Path $OutputPath -ChildPath "$moduleName.$moduleVersion.nupkg"
    Rename-Item -Path $nupkgPath -NewName "$moduleName.$moduleVersion.zip"
    $zipPath = Join-Path -Path $OutputPath -ChildPath "$moduleName.$moduleVersion.zip"

    Expand-Archive -Path $zipPath -DestinationPath $destPath -Force
}
