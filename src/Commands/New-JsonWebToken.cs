using System.Collections;
using System.Management.Automation;
using Jose;
using PoshJsonWebToken.Common;

namespace PoshJsonWebToken.Commands;

[Cmdlet(VerbsCommon.New, "JsonWebToken")]
public sealed class NewJsonWebTokenCommand : JsonWebTokenCommandBase
{
    [Parameter(Mandatory = true)]
    public Hashtable Payload { get; set; }

    [Parameter(Mandatory = true)]
    public JwsAlgorithm Algorithm { get; set; }

    [Parameter(Mandatory = false)]
    public Hashtable ExtraHeader { get; set; }

    protected override void ProcessRecord()
    {
        string token = JWT.Encode(
            payload: Payload.ToDictionary<string, object>(),
            GetTokenSigningKey(Algorithm),
            Algorithm,
            extraHeaders: ExtraHeader?.ToDictionary<string, object>());

        WriteObject(token.ToSecureString());
    }
}
