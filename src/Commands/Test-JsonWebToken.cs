using System;
using System.Management.Automation;
using System.Security;
using Jose;
using PoshJsonWebToken.Common;

namespace PoshJsonWebToken.Commands;

/// <summary>
/// Implementation for Test-JsonWebToken cmdlet.
/// </summary>
[Cmdlet(VerbsDiagnostic.Test, "JsonWebToken")]
public sealed class TestJsonWebTokenCommand : JsonWebTokenCommandBase
{
    #region Parameters

    /// <summary>
    /// The JWT token to decode.
    /// </summary>
    [Parameter(Mandatory = true, ParameterSetName = SecretKeyParameterSet)]
    [Parameter(Mandatory = true, ParameterSetName = CertificateParameterSet)]
    [Parameter(Mandatory = true, ParameterSetName = NoneParameterSet)]
    public SecureString Token { get; set; }

    #endregion Parameters

    #region Overrides

    /// <summary>
    /// Process record.
    /// </summary>
    protected override void ProcessRecord()
    {
        bool result;

        try
        {
            if (AlgorithmHelpers.TryParseJwsAlgorithm(Algorithm, out JwsAlgorithm jwsAlgorithm))
            {
                JWT.Decode(
                    token: Token.ToPlainText(),
                    key: GetTokenSigningKey(jwsAlgorithm),
                    alg: jwsAlgorithm);
            }
            else if (AlgorithmHelpers.TryParseJweAlgorithm(Algorithm, out JweAlgorithm jweAlgorithm))
            {
                if (AlgorithmHelpers.TryParseJweEncryption(Encryption, out JweEncryption jweEncryption))
                {
                    JWT.Decode(
                        token: Token.ToPlainText(),
                        key: GetTokenEncryptionKey(jweAlgorithm),
                        alg: jweAlgorithm,
                        enc: jweEncryption);
                }
                else
                {
                    AlgorithmHelpers.ReportInvalidJweEncryption(this, Encryption);
                }
            }
            else
            {
                AlgorithmHelpers.ReportInvalidAlgorithm(this, Algorithm);
            }

            result = true;
        }
        catch (PipelineStoppedException)
        {
            throw;
        }
        catch (Exception exception)
        {
            var errorRecord = new ErrorRecord(
                exception,
                "InvalidJsonWebToken",
                ErrorCategory.InvalidData,
                Token);

            WriteError(errorRecord);
            result = false;
        }

        WriteObject(result);
    }

    #endregion Overrides
}
