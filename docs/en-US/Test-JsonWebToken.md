---
external help file: PoshJsonWebToken.dll-Help.xml
Module Name: PoshJsonWebToken
online version:
schema: 2.0.0
---

# Test-JsonWebToken

## SYNOPSIS

Tests Json Web Token (JWT) is valid.

## SYNTAX

### SecretKey

```powershell
Test-JsonWebToken -Token <SecureString> -Algorithm <JwsAlgorithm> -SecretKey <SecureString>
 [<CommonParameters>]
```

### Certificate

```powershell
Test-JsonWebToken -Token <SecureString> -Algorithm <JwsAlgorithm> -Certificate <X509Certificate2>
 [<CommonParameters>]
```

## DESCRIPTION

The `Test-JsonWebToken` cmdlet can be used to ensure Json Web Token (JWT) is valid.

The following symmetric hash algorithms support secret key:

+ `HS256` - HMAC with SHA-256
+ `HS384` - HMAC with SHA-384
+ `HS512` - HMAC with SHA-512

The following asymmetric hash algorithms support certificates:

+ `RS256` - RSA Signature with SHA-256
+ `RS384` - RSA Signature with SHA-384
+ `RS512` - RSA Signature with SHA-512
+ `ES256` - P-256 curve and SHA-256
+ `ES384` - P-384 curve and SHA-384
+ `ES512` - P-512 curve and SHA-512

The above algorithms ensures *strict validation* is performed on the Json Web Token (JWT).
This means that you will specify which algorithm you are expecting to receive in the header.

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

## PARAMETERS

### -Algorithm

The hash algorithm.
Currently PS256, PS384 and PS512 algorithms are not supported.

```yaml
Type: JwsAlgorithm
Parameter Sets: (All)
Aliases:
Accepted values: none, HS256, HS384, HS512, RS256, RS384, RS512, PS256, PS384, PS512, ES256, ES384, ES512

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Certificate

The signing certificate of type `System.Security.Cryptography.X509Certificates.X509Certificate2`.
Must be specified and contain the private key if the algorithm is RS256, RS384, RS512, ES256, ES384 or ES512.

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

The HMAC secret secret key.
Must be specified if the algorithm is HS256, HS384 or HS512.

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

The signed JWT token to validate.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Boolean

If JWT token is valid this cmdlet returns `True`, otherwise an exception is thrown and the cmdlet returns `False`.

## NOTES

## RELATED LINKS
