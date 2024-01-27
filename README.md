# PoshJsonWebToken

Another PowerShell module for generating and validating JWT tokens.

While there are a few other JWT PowerShell modules on the gallery this module includes the following features:

+ Broad hash algorithm support:
  + HS256
  + HS384
  + HS512
  + RS256
  + RS384
  + RS512
  + ES256
  + ES384
  + ES512

+ Uses the ultimate [`jose-jwt`](https://www.nuget.org/packages/jose-jwt/) nuget package to get a wide variety of builtin JWT support into PowerShell.

## Requirements

These cmdlets have the following requirements:

+ PowerShell v7.2 or newer.

I may decide to also include PowerShell v5.1 support down the line if needed.

## Examples

Creating a HS256 JWT token using secret key:

```powershell
$payload = @{ 'a' = 'b' }
$header = @{ 'exp' = 1300819380 }
$secretKey = 'abc' | ConvertTo-SecureString -AsPlainText -Force
$algorithm = 'HS256'

# Generate JWT token
$token = New-JsonWebToken -Payload $Payload -Algorithm $algorithm -SecretKey $SecretKey -ExtraHeader $ExtraHeader

# Validate JWT token
Test-JsonWebToken -Token $token -SecretKey $SecretKey -Algorithm $algorithm
```

Creating a RS256 JWT token using certificate:

```powershell
$payload = @{ 'a' = 'b' }
$header = @{ 'exp' = 1300819380 }
$algorithm = 'RS256'

$certificatePath = Resolve-Path -Path 'cert.p12'
$certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificatePath)

# Generate JWT token
$token = New-JsonWebToken -Payload $Payload -Algorithm $algorithm -Certificate $certificate -ExtraHeader $ExtraHeader

# Validate JWT token
Test-JsonWebToken -Token $token -Certificate $certificate -Algorithm $algorithm
```

## Installing

You can install this module by running:

```powershell
# Install for only the current user
Install-Module -Name PoshJsonWebToken -Scope CurrentUser

# Install for all users
Install-Module -Name PoshJsonWebToken -Scope AllUsers
```

## Contributing

Contributing is quite easy, fork this repo and submit a pull request with the changes.
To build this module run `.\build.ps1` in PowerShell.
To test a build run `.\build.ps1 -Task Test` in PowerShell.
This script will ensure all dependencies are installed before running the test suite.
