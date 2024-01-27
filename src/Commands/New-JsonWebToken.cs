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
    [Parameter(Mandatory = true)]
    public Hashtable Payload { get; set; }

    /// <summary>
    /// The hash algorithm used to encode JWT token.
    /// </summary>
    [Parameter(Mandatory = true)]
    public JwsAlgorithm Algorithm { get; set; }

    /// <summary>
    /// The extra headers used to encode JWT token.
    /// </summary>
    [Parameter(Mandatory = false)]
    public Hashtable ExtraHeader { get; set; }

    #endregion Parameters

    #region Overrides

    /// <summary>
    /// Process record.
    /// </summary>
    protected override void ProcessRecord()
    {
        string token = JWT.Encode(
            payload: Payload.ToDictionary<string, object>(),
            GetTokenSigningKey(Algorithm),
            Algorithm,
            extraHeaders: ExtraHeader?.ToDictionary<string, object>());

        WriteObject(token.ToSecureString());
    }

    #endregion Overrides
}
