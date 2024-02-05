# PoshJsonWebToken

Another PowerShell module for generating and validating JWT tokens.

While there are a few other JWT PowerShell modules on the gallery this module includes the following features:

+ Broad hash algorithm support:

  + Signing

    + `HS256`, `HS384` and `HS512` HMAC signatures.
    + `ES256`, `ES384` and `ES512` ECDSA signatures.
    + `RS256`, `RS384` and `RS512` RSASSA-PKCS1-V1_5 signatures.
    + `none` (unprotected) plain text algorithm without integrity protection.

  + Encryption

    + `RSAES_OAEP_256` (using SHA-256 and MGF1 with SHA-256) encryption with `A128CBC_HS256`, `A192CBC_HS384`, `A256CBC_HS512`, `A128GCM`, `A192GCM`, `A256GCM`.
    + `RSAES_OAEP` (using SHA-1 and MGF1 with SHA-1) encryption with `A128CBC_HS256`, `A192CBC_HS384`, `A256CBC_HS512`, `A128GCM`, `A192GCM`, `A256GCM`.
    + `RSA1_5` (RSAES-PKCS1-V1_5) encryption with `A128CBC_HS256`, `A192CBC_HS384`, `A256CBC_HS512`, `A128GCM`, `A192GCM`, `A256GCM`.
    + `DIR` (Direct symmetric key) encryption with pre-shared key `A128CBC_HS256`, `A192CBC_HS384`, `A256CBC_HS512`, `A128GCM`, `A192GCM`, `A256GCM`.
    + `A128KW`, `A192KW`, `A256KW` (AES Key Wrap) encryption with `A128CBC_HS256`, `A192CBC_HS384`, `A256CBC_HS512`, `A128GCM`, `A192GCM`, `A256GCM`.
    + `A128GCMKW`, `A192GCMKW`, `A256GCMKW` (AES GCM Key Wrap) encryption with `A128CBC_HS256`, `A192CBC_HS384`, `A256CBC_HS512`, `A128GCM`, `A192GCM`, `A256GCM`.
    + `PBES2_HS256_A128KW`, `PBES2_HS384_A192KW`, `PBES2_HS512_A256KW` (Password-Based Encryption Scheme 2) with `A128CBC_HS256`, `A192CBC_HS384`, `A256CBC_HS512`, `A128GCM`, `A192GCM`, `A256GCM`.

+ Uses the ultimate [`jose-jwt`](https://www.nuget.org/packages/jose-jwt/) nuget package to get a wide variety of builtin JWT support into PowerShell.

## Requirements

These cmdlets have the following requirements:

+ PowerShell v7.2 or newer.

I may decide to also include PowerShell v5.1 support down the line if needed.

## Examples

Creating a HS256 signed JWT token using secret key:

```powershell
$payload = @{ 'a' = 'b' }
$header = @{ 'exp' = 1300819380 }
$secretKey = 'abc' | ConvertTo-SecureString -AsPlainText -Force
$algorithm = 'HS256'

# Generate JWT token
$token = New-JsonWebToken -Payload $Payload -Algorithm $algorithm -SecretKey $SecretKey -ExtraHeader $header

# Validate JWT token
Test-JsonWebToken -Token $token -SecretKey $SecretKey -Algorithm $algorithm
```

Creating a RS256 signed JWT token using certificate:

```powershell
$payload = @{ 'a' = 'b' }
$header = @{ 'exp' = 1300819380 }
$algorithm = 'RS256'

$certificatePath = Resolve-Path -Path 'cert.p12'
$certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificatePath)

# Generate JWT token
$token = New-JsonWebToken -Payload $Payload -Algorithm $algorithm -Certificate $certificate -ExtraHeader $header

# Validate JWT token
Test-JsonWebToken -Token $token -Certificate $certificate -Algorithm $algorithm
```

Creating a RSA_OAEP encrypted JWT token with A256GCM using certificate:

```powershell
$payload = @{ 'a' = 'b' }
$header = @{ 'exp' = 1300819380 }
$algorithm = 'RSA_OAEP'
$encryption = 'A256GCM'

$certificatePath = Resolve-Path -Path 'cert.p12'
$certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificatePath)

# Generate JWT token
$token = New-JsonWebToken -Payload $Payload -Algorithm $algorithm -Encryption $encryption -Certificate $certificate -ExtraHeader $header

# Validate JWT token
Test-JsonWebToken -Token $token -Certificate $certificate -Algorithm $algorithm -Encryption $encryption
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
