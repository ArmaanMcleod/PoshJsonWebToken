using System.Collections;
using System.Management.Automation;
using Jose;
using PoshJsonWebToken.Common;

namespace PoshJsonWebToken.Commands;

/// <summary>
/// Implementation for New-JsonWebToken cmdlet.
/// </summary>
[Cmdlet(VerbsCommon.New, "JsonWebToken")]
public sealed class NewJsonWebTokenCommand : JsonWebTokenCommandBase
{
    #region Parameters

    /// <summary>
    /// The payload to encode into JWT token.
    /// </summary>
    [Parameter(Mandatory = true, ParameterSetName = SecretKeyParameterSet)]
    [Parameter(Mandatory = true, ParameterSetName = CertificateParameterSet)]
    [Parameter(Mandatory = true, ParameterSetName = NoneParameterSet)]
    public Hashtable Payload { get; set; }

    /// <summary>
    /// The extra headers used to encode JWT token.
    /// </summary>
    [Parameter(Mandatory = false, ParameterSetName = SecretKeyParameterSet)]
    [Parameter(Mandatory = false, ParameterSetName = CertificateParameterSet)]
    [Parameter(Mandatory = false, ParameterSetName = NoneParameterSet)]
    public Hashtable ExtraHeader { get; set; }

    #endregion Parameters

    #region Overrides

    /// <summary>
    /// Process record.
    /// </summary>
    protected override void ProcessRecord()
    {
        if (AlgorithmHelpers.TryParseJwsAlgorithm(Algorithm, out JwsAlgorithm jwsAlgorithm))
        {
            string token = JWT.Encode(
                payload: Payload.ToDictionary<string, object>(),
                GetTokenSigningKey(jwsAlgorithm),
                jwsAlgorithm,
                extraHeaders: ExtraHeader?.ToDictionary<string, object>());

            WriteObject(token.ToSecureString());
        }
        else
        {
            AlgorithmHelpers.ReportInvalidAlgorithm(this, Algorithm);
        }
    }

    #endregion Overrides
}
