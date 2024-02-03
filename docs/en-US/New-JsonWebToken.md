---
external help file: PoshJsonWebToken.dll-Help.xml
Module Name: PoshJsonWebToken
online version:
schema: 2.0.0
---

# New-JsonWebToken

## SYNOPSIS

Creates a signed Json Web Token (JWT).

## SYNTAX

### SecretKey

```powershell
New-JsonWebToken -Payload <Hashtable> -Algorithm <JwsAlgorithm> [-ExtraHeader <Hashtable>]
 -SecretKey <SecureString> [<CommonParameters>]
```

### Certificate

```powershell
New-JsonWebToken -Payload <Hashtable> -Algorithm <JwsAlgorithm> [-ExtraHeader <Hashtable>]
 -Certificate <X509Certificate2> [<CommonParameters>]
```

### None

```powershell
New-JsonWebToken -Payload <Hashtable> -Algorithm <JwsAlgorithm> [-ExtraHeader <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION

The `New-JsonWebToken` cmdlet can be used to create a new Json Web Token (JWT) using a secret key or certificate.

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

The above algorithms have their advantages and disadvantages, depending on the use case and the level of security required.

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

## PARAMETERS

### -Algorithm

The hash algorithm.
Currently PS256, PS384 and PS512 algorithms are not supported.
If `none` is used, a warning message is displayed indicating plain text algorithm is used without integrity protection.

```yaml
Type: String
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

### -ExtraHeader

The extra headers needed to sign JWT token.
These headers are not including the `alg` header which is passed using `-Algorithm` parameter.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Security.SecureString

Output is secured so Json Web Token (JWT) encrypyted string is not exposed.

## NOTES

## RELATED LINKS
