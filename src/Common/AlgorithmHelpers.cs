using System;
using System.Management.Automation;
using System.Security;
using System.Security.Cryptography.X509Certificates;
using Jose;
using PoshJsonWebToken.Resources;

namespace PoshJsonWebToken.Common;

/// <summary>
/// Class which defines algorithm helper methods
/// </summary>
internal static class AlgorithmHelpers
{
    /// <summary>
    /// Determines Json Web Signature (JWS) algorithm family an algorithm belongs to.
    /// </summary>
    /// <param name="algorithm">The hash algorithm.</param>
    /// <returns>The algorithm family.</returns>
    internal static JwsAlgorithmFamily GetJwsAlgorithmFamily(JwsAlgorithm algorithm)
    {
        return algorithm switch
        {
            JwsAlgorithm.HS256 or JwsAlgorithm.HS384 or JwsAlgorithm.HS512 => JwsAlgorithmFamily.HS,
            JwsAlgorithm.RS256 or JwsAlgorithm.RS384 or JwsAlgorithm.RS512 => JwsAlgorithmFamily.RS,
            JwsAlgorithm.ES256 or JwsAlgorithm.ES384 or JwsAlgorithm.ES512 => JwsAlgorithmFamily.ES,
            _ => JwsAlgorithmFamily.Unknown,
        };
    }

    /// <summary>
    /// Throws expection if incorrect algorithm is used with secret key.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="secretKey">The secret key.</param>
    internal static void ReportInvalidSecretKeyAlgorithm(PSCmdlet cmdlet, SecureString secretKey)
    {
        var algorithms = string.Join(
            ",",
            JwsAlgorithm.HS256,
            JwsAlgorithm.HS384,
            JwsAlgorithm.HS512);

        var errorMessage = string.Format(AlgorithmStrings.SecretRequiredAlgorithms, algorithms);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.SecretRequiredAlgorithms),
            ErrorCategory.InvalidArgument,
            secretKey);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws expection if incorrect algorithm is used with certificate.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="certificate">The X509 certificate.</param>
    internal static void ReportInvalidCertificateAlgorithm(PSCmdlet cmdlet, X509Certificate2 certificate)
    {
        var algorithms = string.Join(
            ",",
            JwsAlgorithm.RS256,
            JwsAlgorithm.RS384,
            JwsAlgorithm.RS512,
            JwsAlgorithm.ES256,
            JwsAlgorithm.ES384,
            JwsAlgorithm.ES512);

        var errorMessage = string.Format(AlgorithmStrings.CertificateRequiredAlgorithms, algorithms);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.CertificateRequiredAlgorithms),
            ErrorCategory.InvalidArgument,
            certificate);
        cmdlet.ThrowTerminatingError(errorRecord);
    }

    /// <summary>
    /// Throws an exception if algorithm is used without key.
    /// </summary>
    /// <param name="cmdlet">The cmdlet.</param>
    /// <param name="algorithm">The hash algorithm.</param>
    internal static void ReportAlgorithmWithoutKey(PSCmdlet cmdlet, JwsAlgorithm algorithm)
    {
        var errorMessage = string.Format(AlgorithmStrings.AlgorithmRequiresKey, algorithm);
        var exception = new ArgumentException(errorMessage);
        var errorRecord = new ErrorRecord(
            exception,
            nameof(AlgorithmStrings.AlgorithmRequiresKey),
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
            JwsAlgorithm.ES512);

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
        => Enum.TryParse(algorithm, ignoreCase: true, out jwsAlgorithm);
}
