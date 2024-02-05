---
external help file: PoshJsonWebToken.dll-Help.xml
Module Name: PoshJsonWebToken
online version:
schema: 2.0.0
---

# New-JsonWebToken

## SYNOPSIS

Creates a signed or encrypted Json Web Token (JWT).

## SYNTAX

### SecretKey
```
New-JsonWebToken -Payload <Hashtable> [-ExtraHeader <Hashtable>] -Algorithm <String> [-Encryption <String>]
 -SecretKey <SecureString> [<CommonParameters>]
```

### Certificate
```
New-JsonWebToken -Payload <Hashtable> [-ExtraHeader <Hashtable>] -Algorithm <String> [-Encryption <String>]
 -Certificate <X509Certificate2> [<CommonParameters>]
```

### None
```
New-JsonWebToken -Payload <Hashtable> [-ExtraHeader <Hashtable>] -Algorithm <String> [<CommonParameters>]
```

## DESCRIPTION

The `New-JsonWebToken` cmdlet can be used to create a new signed or encrypted Json Web Token (JWT) using a secret key or certificate.

## EXAMPLES

### Example 1

```powershell
$payload = @{ 'a' = 'b' }
$header = @{ 'exp' = 1300819380 }
$secretKey = 'abc' | ConvertTo-SecureString -AsPlainText -Force
$algorithm = 'HS256'

# Generate JWT token
$token = New-JsonWebToken -Payload $Payload -Algorithm $algorithm -SecretKey $SecretKey -ExtraHeader $header
```

Creating a HS256 JWT token using secret key.

### Example 2

```powershell
$payload = @{ 'a' = 'b' }
$header = @{ 'exp' = 1300819380 }
$algorithm = 'RS256'

$certificatePath = Resolve-Path -Path 'cert.p12'
$certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificatePath)

# Generate JWT token
$token = New-JsonWebToken -Payload $Payload -Algorithm $algorithm -Certificate $certificate -ExtraHeader $header
```

Creating a RS256 JWT token using certificate.

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

Creating a RSA_OAEP encrypted JWT token with A256GCM using certificate.

## PARAMETERS

### -Algorithm

The JWS (Json Web Signature) or JWE (Json Web Encryption) hash algorithm.
If `none` JWS algorithm is used, a warning message is displayed indicating plain text algorithm is used without integrity protection.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

### -Encryption

The encryption used for JWE (Json Web Encryption) JWT tokens.

```yaml
Type: String
Parameter Sets: SecretKey, Certificate
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtraHeader

The extra headers needed to sign JWT token.
These headers are not including the `alg` header which is passed using `-Algorithm` parameter and `enc` header which is passed using `-Encryption` parameter.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Payload

The payload containing the claims to sign.

```yaml
Type: Hashtable
Parameter Sets: (All)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Security.SecureString

Output is secured so Json Web Token (JWT) encrypyted string is not exposed.

## NOTES

## RELATED LINKS
