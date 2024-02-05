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
    /// The hash algorithm used to encode JWT token.
    /// </summary>
    [Parameter(Mandatory = true, ParameterSetName = SecretKeyParameterSet)]
    [Parameter(Mandatory = true, ParameterSetName = CertificateParameterSet)]
    [Parameter(Mandatory = true, ParameterSetName = NoneParameterSet)]
    [ArgumentCompleter(typeof(AlgorithmCompleter))]
    public string Algorithm { get; set; }

    [Parameter(Mandatory = false, ParameterSetName = SecretKeyParameterSet)]
    [Parameter(Mandatory = false, ParameterSetName = CertificateParameterSet)]
    [ArgumentCompleter(typeof(EncryptionCompleter))]
    public string Encryption { get; set; }

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
    /// Method used to determine Json Web Signature (JWS) hash algorithm signing key.
    /// </summary>
    /// <param name="algorithm">The hash algorithm</param>
    /// <returns>The signing key object.</returns>
    protected object GetTokenSigningKey(JwsAlgorithm algorithm)
    {
        object key = null;

        if (MyInvocation.BoundParameters.ContainsKey(nameof(Encryption)))
        {
            AlgorithmHelpers.ReportEncryptionRequiredWithJweAlgorithm(this, Encryption);
        }

        if (ParameterSetName.Equals(NoneParameterSet, StringComparison.OrdinalIgnoreCase))
        {
            if (algorithm == JwsAlgorithm.none)
            {
                WriteWarning(AlgorithmStrings.NoneJwsAlgorithmWarning);
                return key;
            }
            else
            {
                AlgorithmHelpers.ReportJwsAlgorithmWithoutKey(this, algorithm);
            }
        }

        var algorithmFamily = AlgorithmHelpers.GetJwsAlgorithmFamily(algorithm);

        if (ParameterSetName.Equals(SecretKeyParameterSet, StringComparison.OrdinalIgnoreCase))
        {
            if (algorithmFamily == JwsAlgorithmFamily.HS)
            {
                key = Encoding.UTF8.GetBytes(SecretKey.ToPlainText());
            }
            else
            {
                AlgorithmHelpers.ReportInvalidSecretKeyJwsAlgorithm(this, SecretKey);
            }
        }
        else if (ParameterSetName.Equals(CertificateParameterSet, StringComparison.OrdinalIgnoreCase))
        {
            if (algorithmFamily == JwsAlgorithmFamily.RS)
            {
                key = Certificate.GetRSAPrivateKey();
            }
            else if (algorithmFamily == JwsAlgorithmFamily.ES)
            {
                key = Certificate.GetECDsaPrivateKey();
            }
            else
            {
                AlgorithmHelpers.ReportInvalidCertificateJwsAlgorithm(this, Certificate);
            }
        }

        return key;
    }

    /// <summary>
    /// Method used to determine Json Web Encryption (JWE) hash algorithm encryption key.
    /// </summary>
    /// <param name="algorithm"></param>
    /// <returns></returns>
    protected object GetTokenEncryptionKey(JweAlgorithm algorithm)
    {
        object key = null;

        if (!MyInvocation.BoundParameters.ContainsKey(nameof(Encryption)))
        {
            AlgorithmHelpers.ReportEncryptionRequiredWithJweAlgorithm(this, Encryption);
        }

        var algorithmFamily = AlgorithmHelpers.GetJweAlgorithmFamily(algorithm);

        if (ParameterSetName.Equals(SecretKeyParameterSet, StringComparison.OrdinalIgnoreCase))
        {
            if (algorithmFamily is JweAlgorithmFamily.DIR
                or JweAlgorithmFamily.AESKeyWrap
                or JweAlgorithmFamily.AESGCMKeyWrap)
            {
                key = Encoding.UTF8.GetBytes(SecretKey.ToPlainText());
            }
            else if (algorithmFamily == JweAlgorithmFamily.PBES2)
            {
                key = SecretKey.ToPlainText();
            }
            else
            {
                AlgorithmHelpers.ReportInvalidSecretKeyJweAlgorithm(this, SecretKey);
            }
        }

        else if (ParameterSetName.Equals(CertificateParameterSet, StringComparison.OrdinalIgnoreCase))
        {
            if (algorithmFamily == JweAlgorithmFamily.RSA)
            {
                key = Certificate.GetRSAPrivateKey();
            }
            else
            {
                AlgorithmHelpers.ReportInvalidCertificateJweAlgorithm(this, Certificate);
            }
        }

        return key;
    }

    #endregion Protected Members
}
