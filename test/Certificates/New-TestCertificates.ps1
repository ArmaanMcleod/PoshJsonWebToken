[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet('RS256', 'RS384', 'RS512', 'ES256', 'ES384', 'ES512', 'RSA')]
    [string]
    $Algorithm
)

$folderPath = Join-Path -Path $PSScriptRoot -ChildPath $Algorithm
New-Item -Path $folderPath -ItemType Directory -Force

$privateKeyPath = Join-Path -Path $folderPath -ChildPath privatekey.pem
$publicKeyPath = Join-Path -Path $folderPath -ChildPath publickey.pem
$selfSignedCertificatePath = Join-Path -Path $folderPath -ChildPath certificate.crt
$pkcsFormatCertificatePath = Join-Path -Path $folderPath -ChildPath certificate.pfx

if ($Algorithm -eq 'RS256') {
    openssl genrsa -aes256 -out $privateKeyPath -passout pass:'' 2048
    openssl req -x509 -sha256 -days 365 -key $privateKeyPath -out $selfSignedCertificatePath -passin pass:'' -subj '/CN=www.mydom.com/O=My Company Name LTD./C=US'
    openssl pkcs12 -export -out $pkcsFormatCertificatePath -inkey $privateKeyPath -in $selfSignedCertificatePath -passin pass:'' -password pass:''
}

if ($Algorithm -eq 'RS384') {
    openssl genrsa -aes256 -out $privateKeyPath -passout pass:'' 3072
    openssl req -x509 -sha384 -days 365 -key $privateKeyPath -out $selfSignedCertificatePath -passin pass:'' -subj '/CN=www.mydom.com/O=My Company Name LTD./C=US'
    openssl pkcs12 -export -out $pkcsFormatCertificatePath -inkey $privateKeyPath -in $selfSignedCertificatePath -passin pass:'' -password pass:''
}

if ($Algorithm -eq 'RS512') {
    openssl genrsa -aes256 -out $privateKeyPath -passout pass:'' 4096
    openssl req -x509 -sha512 -days 365 -key $privateKeyPath -out $selfSignedCertificatePath -passin pass:'' -subj '/CN=www.mydom.com/O=My Company Name LTD./C=US'
    openssl pkcs12 -export -out $pkcsFormatCertificatePath -inkey $privateKeyPath -in $selfSignedCertificatePath -passin pass:'' -password pass:''
}

if ($Algorithm -eq 'ES256') {
    openssl ecparam -name prime256v1 -genkey -noout -out $privateKeyPath
    openssl req -x509 -sha256 -nodes -days 365 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -keyout $privateKeyPath -out $selfSignedCertificatePath -subj '/CN=www.mydom.com/O=My Company Name LTD./C=US'
    openssl pkcs12 -export -out $pkcsFormatCertificatePath -inkey $privateKeyPath -in $selfSignedCertificatePath -password pass:''
}

if ($Algorithm -eq 'ES384') {
    openssl ecparam -name secp384r1 -genkey -noout -out $privateKeyPath
    openssl req -x509 -sha384 -nodes -days 365 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 -keyout $privateKeyPath -out $selfSignedCertificatePath -subj '/CN=www.mydom.com/O=My Company Name LTD./C=US'
    openssl pkcs12 -export -out $pkcsFormatCertificatePath -inkey $privateKeyPath -in $selfSignedCertificatePath -password pass:''
}

if ($Algorithm -eq 'ES512') {
    openssl ecparam -name secp521r1 -genkey -noout -out $privateKeyPath
    openssl req -x509 -sha512 -nodes -days 365 -newkey ec -pkeyopt ec_paramgen_curve:secp521r1 -keyout $privateKeyPath -out $selfSignedCertificatePath -subj '/CN=www.mydom.com/O=My Company Name LTD./C=US'
    openssl pkcs12 -export -out $pkcsFormatCertificatePath -inkey $privateKeyPath -in $selfSignedCertificatePath -password pass:''
}

if ($Algorithm -eq 'RSA') {
    openssl genpkey -algorithm RSA -out $privateKeyPath
    openssl rsa -pubout -in $privateKeyPath -out $publicKeyPath
    openssl req -key $privateKeyPath -new -x509 -days 365 -out $selfSignedCertificatePath -subj '/CN=www.mydom.com/O=My Company Name LTD./C=US'
    openssl pkcs12 -export -in $selfSignedCertificatePath -inkey $privateKeyPath -out $pkcsFormatCertificatePath -password pass:''
}
