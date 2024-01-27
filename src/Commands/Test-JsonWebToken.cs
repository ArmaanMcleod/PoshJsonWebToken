using System;
using System.Management.Automation;
using System.Security;
using Jose;
using PoshJsonWebToken.Common;

namespace PoshJsonWebToken.Commands;

[Cmdlet(VerbsDiagnostic.Test, "JsonWebToken")]
public sealed class TestJsonWebTokenCommand : JsonWebTokenCommandBase
{
    [Parameter(Mandatory = true)]
    public SecureString Token { get; set; }

    [Parameter(Mandatory = true)]
    public JwsAlgorithm Algorithm { get; set; }

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
}
