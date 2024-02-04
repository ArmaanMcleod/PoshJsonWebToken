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
    private static readonly HashSet<string> excludedJwsAlgorithms = new()
    {
        "PS256",
        "PS384",
        "PS512"
    };

    private static readonly HashSet<string> excludedJweAlgorithms = new()
    {
        "ECDH_ES",
        "ECDH_ES_A128KW",
        "ECDH_ES_A192KW",
        "ECDH_ES_A256KW"
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
        string quote = ArgumentCompleterHelpers.HandleDoubleAndSingleQuote(ref wordToComplete);

        var algorithmPattern = WildcardPattern.Get(wordToComplete + "*", WildcardOptions.IgnoreCase);

        foreach (string completionText in ArgumentCompleterHelpers.FilterCompletionText(
            algorithmPattern,
            Enum.GetNames(typeof(JwsAlgorithm)).Where(alg => !excludedJwsAlgorithms.Contains(alg)),
            quote))
        {
            yield return new CompletionResult(completionText);
        }

        foreach (string completionText in ArgumentCompleterHelpers.FilterCompletionText(
            algorithmPattern,
            Enum.GetNames(typeof(JweAlgorithm)).Where(alg => !excludedJweAlgorithms.Contains(alg)),
            quote))
        {
            yield return new CompletionResult(completionText);
        }
    }
}

/// <summary>
/// Provides argument completion for Encryption parameter.
/// </summary>
public class EncryptionCompleter : IArgumentCompleter
{
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
        string quote = ArgumentCompleterHelpers.HandleDoubleAndSingleQuote(ref wordToComplete);

        var encryptionPattern = WildcardPattern.Get(wordToComplete + "*", WildcardOptions.IgnoreCase);

        foreach (string completionText in ArgumentCompleterHelpers.FilterCompletionText(
            encryptionPattern,
            Enum.GetNames(typeof(JweEncryption)),
            quote))
        {
            yield return new CompletionResult(completionText);
        }
    }
}

/// <summary>
/// Class which defines argument completer helper methods.
/// </summary>
internal static class ArgumentCompleterHelpers
{
    /// <summary>
    /// Handles single and double quote completions.
    /// Sets word to complete to quote found so we can do completion with quotes.
    /// </summary>
    /// <param name="wordToComplete">The word to complete.</param>
    /// <returns>The quote string found if any.</returns>
    internal static string HandleDoubleAndSingleQuote(ref string wordToComplete)
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

    /// <summary>
    /// Filters completion text for a given input and pattern.
    /// </summary>
    /// <param name="pattern">The pattern to match against input.</param>
    /// <param name="inputs">The input source.</param>
    /// <param name="quote">The quotes to include in completion text if not empty.</param>
    /// <returns>List of completion text.</returns>
    internal static IEnumerable<string> FilterCompletionText(
        WildcardPattern pattern,
        IEnumerable<string> inputs,
        string quote)
    {
        foreach (string input in inputs)
        {
            if (pattern.IsMatch(input))
            {
                string completionText = quote == string.Empty
                    ? input
                    : quote + input + quote;

                yield return completionText;
            }
        }
    }
}
