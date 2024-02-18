using System;
using System.Management.Automation;
using System.Security;
using System.Security.Cryptography.X509Certificates;
using Jose;
using PoshJsonWebToken.Resources;

namespace PoshJsonWebToken.Common;

/// <summary>
/// Class which defines algorithm helper methods.
/// </summary>
internal static class AlgorithmHelpers
{
    /// <summary>
    /// Determines Json Web Signature (JWS) algorithm family an algorithm belongs to.
    /// </summary>
    /// <param name="algorithm">The hash algorithm.</param>
    /// <returns>The JWS algorithm family.</returns>
    internal static JwsAlgorithmFamily GetJwsAlgorithmFamily(JwsAlgorithm algorithm)
    {
        return algorithm switch
        {
            JwsAlgorithm.HS256
                or JwsAlgorithm.HS384
                or JwsAlgorithm.HS512
                => JwsAlgorithmFamily.HS,

            JwsAlgorithm.RS256
                or JwsAlgorithm.RS384
                or JwsAlgorithm.RS512
                => JwsAlgorithmFamily.RS,

            JwsAlgorithm.ES256
                or JwsAlgorithm.ES384
                or JwsAlgorithm.ES512
                => JwsAlgorithmFamily.ES,

            _ => JwsAlgorithmFamily.Unknown,
        };
    }

    /// <summary>
    /// Determines Json Web Encryption (JWE) algorithm family an algorithm belongs to.
    /// </summary>
    /// <param name="algorithm">The hash algorithm.</param>
    /// <returns>The JWE algorithm family.</returns>
    internal static JweAlgorithmFamily GetJweAlgorithmFamily(JweAlgorithm algorithm)
    {
        return algorithm switch
        {
            JweAlgorithm.RSA_OAEP_256
                or JweAlgorithm.RSA_OAEP
                or JweAlgorithm.RSA1_5
                => JweAlgorithmFamily.RSA,

            JweAlgorithm.DIR => JweAlgorithmFamily.DIR,

            JweAlgorithm.A128KW
                or JweAlgorithm.A192KW
                or JweAlgorithm.A256KW
                => JweAlgorithmFamily.AESKeyWrap,

            JweAlgorithm.A128GCMKW
                or JweAlgorithm.A192GCMKW
                or JweAlgorithm.A256GCMKW
                => JweAlgorithmFamily.AESGCMKeyWrap,

            JweAlgorithm.PBES2_HS256_A128KW
                or JweAlgorithm.PBES2_HS384_A192KW
                or JweAlgorithm.PBES2_HS512_A256KW
                => JweAlgorithmFamily.PBES2,

            _ => JweAlgorithmFamily.Unknown,
        };
    }

    /// <summary>
    /// Throws exception if Encryption is not used with JWE algorithm.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="encryption">The encryption.</param>
    internal static void ReportEncryptionRequiredWithJweAlgorithm(PSCmdlet cmdlet, string encryption)
    {
        var algorithms = string.Join(
            ",",
            JweAlgorithm.RSA_OAEP_256,
            JweAlgorithm.RSA_OAEP,
            JweAlgorithm.RSA1_5,
            JweAlgorithm.DIR,
            JweAlgorithm.A128KW,
            JweAlgorithm.A192KW,
            JweAlgorithm.A256KW,
            JweAlgorithm.A128GCMKW,
            JweAlgorithm.A192GCMKW,
            JweAlgorithm.A256GCMKW,
            JweAlgorithm.PBES2_HS256_A128KW,
            JweAlgorithm.PBES2_HS384_A192KW,
            JweAlgorithm.PBES2_HS512_A256KW);

        var errorMessage = string.Format(AlgorithmStrings.JweEncryptionRequiredWithJweAlgorithm, algorithms);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.JweEncryptionRequiredWithJweAlgorithm),
            ErrorCategory.InvalidArgument,
            encryption);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws exception if incorrect JWE encryption is used.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="encryption">The encryption.</param>
    internal static void ReportInvalidJweEncryption(PSCmdlet cmdlet, string encryption)
    {
        var encryptions = string.Join(
            ",",
            JweEncryption.A128CBC_HS256,
            JweEncryption.A192CBC_HS384,
            JweEncryption.A256CBC_HS512,
            JweEncryption.A128GCM,
            JweEncryption.A192GCM,
            JweEncryption.A256GCM);

        var errorMessage = string.Format(AlgorithmStrings.InvalidJweEncryption, encryptions);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.InvalidJweEncryption),
            ErrorCategory.InvalidArgument,
            encryption);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws exception if compression is not used with JWE encryption.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="compression">The compression switch parameter.</param>
    internal static void ReportCompressionRequiresJweEncryption(PSCmdlet cmdlet, SwitchParameter compression)
    {
        var encryptions = string.Join(
            ",",
            JweEncryption.A128CBC_HS256,
            JweEncryption.A192CBC_HS384,
            JweEncryption.A256CBC_HS512,
            JweEncryption.A128GCM,
            JweEncryption.A192GCM,
            JweEncryption.A256GCM);

        var errorMessage = string.Format(AlgorithmStrings.CompressionRequiresJweEncryption, encryptions);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.CompressionRequiresJweEncryption),
            ErrorCategory.InvalidArgument,
            compression);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws expection if incorrect JWE algorithm is used with secret key.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="secretKey">The secret key.</param>
    internal static void ReportInvalidSecretKeyJweAlgorithm(PSCmdlet cmdlet, SecureString secretKey)
    {
        var algorithms = string.Join(
            ",",
            JweAlgorithm.DIR,
            JweAlgorithm.A128KW,
            JweAlgorithm.A192KW,
            JweAlgorithm.A256KW,
            JweAlgorithm.A128GCMKW,
            JweAlgorithm.A192GCMKW,
            JweAlgorithm.A256GCMKW,
            JweAlgorithm.PBES2_HS256_A128KW,
            JweAlgorithm.PBES2_HS384_A192KW,
            JweAlgorithm.PBES2_HS512_A256KW);

        var errorMessage = string.Format(AlgorithmStrings.SecretRequiredJweAlgorithms, algorithms);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.SecretRequiredJweAlgorithms),
            ErrorCategory.InvalidArgument,
            secretKey);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws expection if incorrect JWE algorithm is used with certificate.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="certificate">The X509 certificate.</param>
    internal static void ReportInvalidCertificateJweAlgorithm(PSCmdlet cmdlet, X509Certificate2 certificate)
    {
        var algorithms = string.Join(
            ",",
            JweAlgorithm.RSA_OAEP_256,
            JweAlgorithm.RSA_OAEP,
            JweAlgorithm.RSA1_5);

        var errorMessage = string.Format(AlgorithmStrings.CertificateRequiredJweAlgorithms, algorithms);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.CertificateRequiredJweAlgorithms),
            ErrorCategory.InvalidArgument,
            certificate);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws expection if incorrect JWS algorithm is used with secret key.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="secretKey">The secret key.</param>
    internal static void ReportInvalidSecretKeyJwsAlgorithm(PSCmdlet cmdlet, SecureString secretKey)
    {
        var algorithms = string.Join(
            ",",
            JwsAlgorithm.HS256,
            JwsAlgorithm.HS384,
            JwsAlgorithm.HS512);

        var errorMessage = string.Format(AlgorithmStrings.SecretRequiredJwsAlgorithms, algorithms);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.SecretRequiredJwsAlgorithms),
            ErrorCategory.InvalidArgument,
            secretKey);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws expection if incorrect JWS algorithm is used with certificate.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="certificate">The X509 certificate.</param>
    internal static void ReportInvalidCertificateJwsAlgorithm(PSCmdlet cmdlet, X509Certificate2 certificate)
    {
        var algorithms = string.Join(
            ",",
            JwsAlgorithm.RS256,
            JwsAlgorithm.RS384,
            JwsAlgorithm.RS512,
            JwsAlgorithm.ES256,
            JwsAlgorithm.ES384,
            JwsAlgorithm.ES512);

        var errorMessage = string.Format(AlgorithmStrings.CertificateRequiredJwsAlgorithms, algorithms);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.CertificateRequiredJwsAlgorithms),
            ErrorCategory.InvalidArgument,
            certificate);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws an exception if JWS algorithm is used without key.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="algorithm">The hash algorithm.</param>
    internal static void ReportJwsAlgorithmWithoutKey(PSCmdlet cmdlet, JwsAlgorithm algorithm)
    {
        var errorMessage = string.Format(AlgorithmStrings.JwsAlgorithmRequiresKey, algorithm);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.JwsAlgorithmRequiresKey),
            ErrorCategory.InvalidArgument,
            algorithm);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws an exception if invalid algorithm is used.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="algorithm">The invalid algorithm.</param>
    internal static void ReportInvalidAlgorithm(PSCmdlet cmdlet, string algorithm)
    {
        var algorithms = string.Join(
            ",",
            JwsAlgorithm.none,
            JwsAlgorithm.HS256,
            JwsAlgorithm.HS384,
            JwsAlgorithm.HS512,
            JwsAlgorithm.RS256,
            JwsAlgorithm.RS384,
            JwsAlgorithm.RS512,
            JwsAlgorithm.ES256,
            JwsAlgorithm.ES384,
            JwsAlgorithm.ES512,
            JweAlgorithm.RSA_OAEP_256,
            JweAlgorithm.RSA_OAEP,
            JweAlgorithm.RSA1_5,
            JweAlgorithm.DIR,
            JweAlgorithm.A128KW,
            JweAlgorithm.A192KW,
            JweAlgorithm.A256KW,
            JweAlgorithm.A128GCMKW,
            JweAlgorithm.A192GCMKW,
            JweAlgorithm.A256GCMKW,
            JweAlgorithm.PBES2_HS256_A128KW,
            JweAlgorithm.PBES2_HS384_A192KW,
            JweAlgorithm.PBES2_HS512_A256KW);

        var errorMessage = string.Format(AlgorithmStrings.InvalidAlgorithm, algorithms);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.InvalidAlgorithm),
            ErrorCategory.InvalidArgument,
            algorithm);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Parses string algorithm into JWS algorithm type.
    /// </summary>
    /// <param name="algorithm">The algorithm to parse.</param>
    /// <param name="jwsAlgorithm">The parsed JWS algorithm.</param>
    /// <returns>Boolean if parsing was successful.</returns>
    internal static bool TryParseJwsAlgorithm(string algorithm, out JwsAlgorithm jwsAlgorithm)
    {
        if (Enum.TryParse(algorithm, ignoreCase: true, out jwsAlgorithm))
        {
            // Exclude PS* algorithms since they are unsupported in this module.
            if (jwsAlgorithm is JwsAlgorithm.PS256
                or JwsAlgorithm.PS384
                or JwsAlgorithm.PS512)
            {
                return false;
            }

            return true;
        }

        return false;
    }

    /// <summary>
    /// Parses string algorithm into JWE algorithm type.
    /// </summary>
    /// <param name="algorithm">The algorithm to parse.</param>
    /// <param name="jweAlgorithm">The parsed JWE algorithm.</param>
    /// <returns>Boolean if parsing was successful.</returns>
    internal static bool TryParseJweAlgorithm(string algorithm, out JweAlgorithm jweAlgorithm)
    {
        if (Enum.TryParse(algorithm, ignoreCase: true, out jweAlgorithm))
        {
            // Exclude ECDH* algorithms since they are unsupported in this module.
            if (jweAlgorithm is JweAlgorithm.ECDH_ES
                or JweAlgorithm.ECDH_ES_A128KW
                or JweAlgorithm.ECDH_ES_A192KW
                or JweAlgorithm.ECDH_ES_A256KW)
            {
                return false;
            }

            return true;
        }

        return false;
    }

    /// <summary>
    /// Parses string encryption into JWE encryption type.
    /// </summary>
    /// <param name="encryption">The encryption to parse.</param>
    /// <param name="jweEncryption">The parsed JWE encryption.</param>
    /// <returns>Boolean if parsing was successful.</returns>
    internal static bool TryParseJweEncryption(string encryption, out JweEncryption jweEncryption)
        => Enum.TryParse(encryption, ignoreCase: true, out jweEncryption);
}
