using System;
using System.Management.Automation;
using System.Security;
using System.Security.Cryptography.X509Certificates;
using Jose;
using PoshJsonWebToken.Resources;

namespace PoshJsonWebToken.Common;

internal static class AlgorithmHelpers
{
    internal static AlgorithmFamily GetAlgorithmFamily(JwsAlgorithm algorithm)
    {
        return algorithm switch
        {
            JwsAlgorithm.HS256 or JwsAlgorithm.HS384 or JwsAlgorithm.HS512 => AlgorithmFamily.HS,
            JwsAlgorithm.RS256 or JwsAlgorithm.RS384 or JwsAlgorithm.RS512 => AlgorithmFamily.RS,
            JwsAlgorithm.ES256 or JwsAlgorithm.ES384 or JwsAlgorithm.ES512 => AlgorithmFamily.ES,
            _ => AlgorithmFamily.Unknown,
        };
    }

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
}
