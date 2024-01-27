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
    [Parameter(Mandatory = true)]
    public SecureString Token { get; set; }

    /// <summary>
    /// The hash algorithm used to encode JWT token.
    /// </summary>
    [Parameter(Mandatory = true)]
    public JwsAlgorithm Algorithm { get; set; }

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
            JWT.Decode(Token.ToPlainText(), GetTokenSigningKey(Algorithm), Algorithm);
            result = true;
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
