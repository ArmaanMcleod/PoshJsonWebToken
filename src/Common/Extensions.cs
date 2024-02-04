using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security;

namespace PoshJsonWebToken.Common;

/// <summary>
/// Class which defines utility extension methods.
/// </summary>
internal static class Extensions
{
    /// <summary>
    /// Converts hashtable to dictionary.
    /// </summary>
    /// <param name="table">The hashtable.</param>
    /// <typeparam name="K">The key type.</typeparam>
    /// <typeparam name="V">The value type.</typeparam>
    /// <returns>Dictionary with K, V types.</returns>
    internal static Dictionary<K, V> ToDictionary<K, V>(this Hashtable table)
        => table
            .Cast<DictionaryEntry>()
            .ToDictionary(kvp => (K)kvp.Key, kvp => (V)kvp.Value);

    /// <summary>
    /// Converts secure string to plain text string.
    /// </summary>
    /// <param name="secureString">The secure string.</param>
    /// <returns>Plain text string.</returns>
    internal static string ToPlainText(this SecureString secureString)
    {
        IntPtr valuePtr = IntPtr.Zero;
        try
        {
            valuePtr = Marshal.SecureStringToBSTR(secureString);
            return Marshal.PtrToStringBSTR(valuePtr);
        }
        finally
        {
            Marshal.ZeroFreeBSTR(valuePtr);
        }
    }

    /// <summary>
    /// Converts string to secure string.
    /// </summary>
    /// <param name="str">The string.</param>
    /// <returns>Secure string.</returns>
    internal static SecureString ToSecureString(this string str)
    {
        unsafe
        {
            fixed (char* chars = str)
            {
                return new SecureString(chars, str.Length);
            }
        }
    }

    /// <summary>
    /// The possible special quote characters.
    /// </summary>
    private static class QuoteChars
    {
        // Special quotes
        internal const char QuoteSingleLeft = (char)0x2018; // left single quotation mark
        internal const char QuoteSingleRight = (char)0x2019; // right single quotation mark
        internal const char QuoteSingleBase = (char)0x201a; // single low-9 quotation mark
        internal const char QuoteReversed = (char)0x201b; // single high-reversed-9 quotation mark
        internal const char QuoteDoubleLeft = (char)0x201c; // left double quotation mark
        internal const char QuoteDoubleRight = (char)0x201d; // right double quotation mark
        internal const char QuoteLowDoubleLeft = (char)0x201E; // low double left quote used in german.
    }

    /// <summary>
    /// Return true if the character is single quote.
    /// </summary>
    /// <param name="c">The character.</param>
    /// <returns>Boolean if character is single quote.</returns>
    internal static bool IsSingleQuote(this char c)
    {
        return c is '\''
            or QuoteChars.QuoteSingleLeft
            or QuoteChars.QuoteSingleRight
            or QuoteChars.QuoteSingleBase
            or QuoteChars.QuoteReversed;
    }

    /// Return true if the character is double quote.
    /// </summary>
    /// <param name="c">The character.</param>
    /// <returns>Boolean if character is double quote.</returns>
    internal static bool IsDoubleQuote(this char c)
    {
        return c is '"'
            or QuoteChars.QuoteDoubleLeft
            or QuoteChars.QuoteDoubleRight
            or QuoteChars.QuoteLowDoubleLeft;
    }
}
