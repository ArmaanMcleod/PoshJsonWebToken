using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Language;
using Jose;

namespace PoshJsonWebToken.Common;

/// <summary>
/// Provides argument completion for Algorithm parameter.
/// </summary>
public class AlgorithmCompleter : IArgumentCompleter
{
    /// <summary>
    /// Excluded JWS algorithms since this module does not support them.
    /// </summary>
    private static readonly string[] excludedJwsAlgorithms = new string[]
    {
        "PS256",
        "PS384",
        "PS512"
    };

    /// <summary>
    /// Returns completion results for Algorithm parameter.
    /// </summary>
    /// <param name="commandName">The command name.</param>
    /// <param name="parameterName">The parameter name.</param>
    /// <param name="wordToComplete">The word to complete.</param>
    /// <param name="commandAst">The command AST.</param>
    /// <param name="fakeBoundParameters">The fake bound parameters.</param>
    /// <returns>List of Completion Results.</returns>
    public IEnumerable<CompletionResult> CompleteArgument(
        string commandName,
        string parameterName,
        string wordToComplete,
        CommandAst commandAst,
        IDictionary fakeBoundParameters)
    {
        string quote = HandleDoubleAndSingleQuote(ref wordToComplete);

        var algorithmPattern = WildcardPattern.Get(wordToComplete + "*", WildcardOptions.IgnoreCase);

        foreach (string jwsAlgorithm in Enum.GetNames(typeof(JwsAlgorithm)))
        {
            if (!excludedJwsAlgorithms.Contains(jwsAlgorithm) && algorithmPattern.IsMatch(jwsAlgorithm))
            {
                string completionText = quote == string.Empty
                    ? jwsAlgorithm
                    : quote + jwsAlgorithm + quote;

                yield return new CompletionResult(completionText);
            }
        }
    }

    /// <summary>
    /// Handles single and double quote completions.
    /// Sets word to complete to quote found so we can do completion with quotes.
    /// </summary>
    /// <param name="wordToComplete">The word to complete.</param>
    /// <returns>The quote string found if any.</returns>
    private static string HandleDoubleAndSingleQuote(ref string wordToComplete)
    {
        string quote = string.Empty;

        if (!string.IsNullOrEmpty(wordToComplete) && (wordToComplete[0].IsSingleQuote() || wordToComplete[0].IsDoubleQuote()))
        {
            char frontQuote = wordToComplete[0];
            int length = wordToComplete.Length;

            if (length == 1)
            {
                wordToComplete = string.Empty;
                quote = frontQuote.IsSingleQuote() ? "'" : "\"";
            }
            else if (length > 1)
            {
                if ((wordToComplete[length - 1].IsDoubleQuote() && frontQuote.IsDoubleQuote()) || (wordToComplete[length - 1].IsSingleQuote() && frontQuote.IsSingleQuote()))
                {
                    wordToComplete = wordToComplete.Substring(1, length - 2);
                    quote = frontQuote.IsSingleQuote() ? "'" : "\"";
                }
                else if (!wordToComplete[length - 1].IsDoubleQuote() && !wordToComplete[length - 1].IsSingleQuote())
                {
                    wordToComplete = wordToComplete.Substring(1);
                    quote = frontQuote.IsSingleQuote() ? "'" : "\"";
                }
            }
        }

        return quote;
    }
}
