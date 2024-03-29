@{
    RootModule           = 'PoshJsonWebToken.psm1'
    ModuleVersion        = '1.1.1'
    CompatiblePSEditions = @('Core')
    GUID                 = 'e77c8d30-6e39-4786-be2d-0da51418d57a'
    Author               = 'ArmaanMcleod'
    Copyright            = '(c) ArmaanMcleod. All rights reserved.'
    Description          = 'This module contains cmdlets to help with generating and validating signed or encrypted JWT tokens.'
    PowerShellVersion    = '7.2'
    CmdletsToExport      = @(
        'New-JsonWebToken'
        'Test-JsonWebToken'
    )
    PrivateData          = @{
        PSData = @{
            Tags         = @(
                'JWT'
                'JsonWebToken'
                'JWS'
                'JsonWebSignature'
                'JWE'
                'JsonWebEncryption'
            )
            LicenseUri   = 'https://github.com/ArmaanMcleod/PoshJsonWebToken/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/ArmaanMcleod/PoshJsonWebToken'
            ReleaseNotes = 'See https://github.com/ArmaanMcleod/PoshJsonWebToken/blob/main/CHANGELOG.md'
        }
    }
}
