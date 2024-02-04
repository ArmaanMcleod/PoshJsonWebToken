---
external help file: PoshJsonWebToken.dll-Help.xml
Module Name: PoshJsonWebToken
online version:
schema: 2.0.0
---

# Test-JsonWebToken

## SYNOPSIS

Tests signed or encrypted Json Web Token (JWT) is valid.

## SYNTAX

### SecretKey

```
Test-JsonWebToken -Token <SecureString> -Algorithm <String> [-Encryption <String>] -SecretKey <SecureString>
 [<CommonParameters>]
```

### Certificate

```
Test-JsonWebToken -Token <SecureString> -Algorithm <String> [-Encryption <String>]
 -Certificate <X509Certificate2> [<CommonParameters>]
```

### None

```
Test-JsonWebToken -Token <SecureString> -Algorithm <String> [-Encryption <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The `Test-JsonWebToken` cmdlet can be used to ensure Json Web Token (JWT) is valid.

This cmdlet also ensures *strict validation* is performed on the Json Web Token (JWT).
This means that you will specify which algorithm and/or encryption you are expecting to receive in the header.

## EXAMPLES

### Example 1

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

Validates signed JWT token using secret key and HS256 algorithm.

### Example 2

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

Validates signed JWT token using certificate and RS256 algorithm.

### Example 3

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

Validating a RSA_OAEP encrypted JWT token with A256GCM using certificate.

## PARAMETERS

### -Algorithm

The JWS (Json Web Signature) or JWE (Json Web Encryption) hash algorithm.
If `none` JWS algorithm is used, a warning message is displayed indicating plain text algorithm is used without integrity protection.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: none, HS256, HS384, HS512, RS256, RS384, RS512, PS256, PS384, PS512, ES256, ES384, ES512, RSA_OAEP_256, RSA_OAEP, RSA1_5, DIR, A128KW, A192KW, A256KW, A128GCMKW, A192GCMKW, A256GCMKW, PBES2_HS256_A128KW, PBES2_HS384_A192KW,
PBES2_HS512_A256KW

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Certificate

The certificate used for signing or encryption.

Supported JWS (Json Web Signature) algorithms:

+ `RS256`
+ `RS384`
+ `RS512`
+ `ES256`
+ `ES384`
+ `ES512`

Supported JWE (Json Web Encryption) algorithms:

+ `RSA_OAEP_256`
+ `RSA_OAEP`
+ `RSA1_5`

```yaml
Type: X509Certificate2
Parameter Sets: Certificate
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecretKey

The secret secret key used for signing or encryption.

Supported JWS (Json Web Signature) algorithms:

+ `HS256`
+ `HS384`
+ `HS512`

Supported JWE (Json Web Encryption) algorithms:

+ `DIR`
+ `A128KW`
+ `A192KW`
+ `A256KW`
+ `A128GCMKW`
+ `A192GCMKW`
+ `A256GCMKW`
+ `PBES2_HS256_A128KW`
+ `PBES2_HS384_A192KW`
+ `PBES2_HS512_A256KW`

```yaml
Type: SecureString
Parameter Sets: SecretKey
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token

The signed or encrypted JWT token to validate.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encryption

The encryption used for JWE (Json Web Encryption) JWT tokens.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: A128CBC_HS256, A192CBC_HS384, A256CBC_HS512, A128GCM, A192GCM, A256GCM

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Boolean

If JWT token is valid this cmdlet returns `True`, otherwise an exception is thrown and the cmdlet returns `False`.

## NOTES

## RELATED LINKS
