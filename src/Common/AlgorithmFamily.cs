namespace PoshJsonWebToken.Common;

internal enum JwsAlgorithmFamily
{
    HS,
    RS,
    ES,
    Unknown
}

internal enum JweAlgorithmFamily
{
    RSA,
    DIR,
    AESKeyWrap,
    AESGCMKeyWrap,
    PBES2,
    Unknown
}
