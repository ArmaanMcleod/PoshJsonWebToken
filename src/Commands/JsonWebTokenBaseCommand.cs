using System;
using System.Management.Automation;
using System.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using Jose;
using PoshJsonWebToken.Common;
using PoshJsonWebToken.Resources;

namespace PoshJsonWebToken.Commands;

/// <summary>
/// Base class for any Json Web Token cmdlet.
/// </summary>
public abstract class JsonWebTokenCommandBase : PSCmdlet
{
    #region Parameter Sets

    protected const string NoneParameterSet = "None";
    protected const string SecretKeyParameterSet = "SecretKey";
    protected const string CertificateParameterSet = "Certificate";

    #endregion Parameter Sets

    #region Parameters

    /// <summary>
    /// Secure key used for signing JWT token.
    /// </summary>
    [Parameter(Mandatory = true, ParameterSetName = SecretKeyParameterSet)]
    public SecureString SecretKey { get; set; }

    /// <summary>
    /// Certificate used for signing JWT token.
    /// </summary>
    [Parameter(Mandatory = true, ParameterSetName = CertificateParameterSet)]
    public X509Certificate2 Certificate { get; set; }

    #endregion Parameters

    #region Protected Members

    /// <summary>
    /// Method used to determine hash algorithm hash signing key.
    /// </summary>
    /// <param name="algorithm">The hash algorithm</param>
    /// <returns>The signing key object.</returns>
    protected object GetTokenSigningKey(JwsAlgorithm algorithm)
    {
        object key = null;

        if (ParameterSetName.Equals(NoneParameterSet, StringComparison.OrdinalIgnoreCase))
        {
            if (algorithm == JwsAlgorithm.none)
            {
                WriteWarning(AlgorithmStrings.NoneAlgorithmWarning);
                return key;
            }
            else
            {
                AlgorithmHelpers.ReportAlgorithmWithoutKey(this, algorithm);
            }
        }

        var algorithmFamily = AlgorithmHelpers.GetAlgorithmFamily(algorithm);

        if (ParameterSetName.Equals(SecretKeyParameterSet, StringComparison.OrdinalIgnoreCase))
        {
            if (algorithmFamily == AlgorithmFamily.HS)
            {
                key = Encoding.UTF8.GetBytes(SecretKey.ToPlainText());
            }
            else
            {
                AlgorithmHelpers.ReportInvalidSecretKeyAlgorithm(this, SecretKey);
            }
        }
        else if (ParameterSetName.Equals(CertificateParameterSet, StringComparison.OrdinalIgnoreCase))
        {
            if (algorithmFamily == AlgorithmFamily.RS)
            {
                key = Certificate.GetRSAPrivateKey();
            }
            else if (algorithmFamily == AlgorithmFamily.ES)
            {
                key = Certificate.GetECDsaPrivateKey();
            }
            else
            {
                AlgorithmHelpers.ReportInvalidCertificateAlgorithm(this, Certificate);
            }
        }

        return key;
    }

    #endregion Protected Members
}
