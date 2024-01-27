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
    internal static Dictionary<K, V> ToDictionary<K, V>(this Hashtable table) => table
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
}
