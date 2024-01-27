using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security;

namespace PoshJsonWebToken.Common;

internal static class Extensions
{
    internal static Dictionary<K, V> ToDictionary<K, V>(this Hashtable table) => table
        .Cast<DictionaryEntry>()
        .ToDictionary(kvp => (K)kvp.Key, kvp => (V)kvp.Value);

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
