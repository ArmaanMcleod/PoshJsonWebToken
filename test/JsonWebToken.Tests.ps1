Describe 'JsonWebToken Tests' {
    BeforeAll {
        Import-Module (Join-Path -Path $PWD -ChildPath 'out' -AdditionalChildPath 'PoshJsonWebToken') -Force;
    }

    BeforeDiscovery {
        $payload = @{ 'a' = 'b' }
        $header = @{ 'exp' = 1300819380 }
        $secretKey = 'abc' | ConvertTo-SecureString -AsPlainText -Force
        $encryptions = 'A128CBC_HS256', 'A192CBC_HS384', 'A256CBC_HS512', 'A128GCM', 'A192GCM', 'A256GCM'
    }

    BeforeAll {
        $payload = @{ 'a' = 'b' }
    }

    Context 'JWT Signing' {

        Context 'HS256 & HS384 & HS512' {

            It "<Title>" -TestCases @(
                @{
                    Payload       = $payload
                    Algorithm     = 'HS256'
                    SecretKey     = $secretKey
                    ExpectedToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhIjoiYiJ9.N1LLr2A9h9deCX5riFKcQ52LkHsb7v6sUktK3py94Jo'
                    Title         = 'Should return expected JWT token using HS256 algorithm and secret key with no headers'
                }
                @{
                    Payload       = $payload
                    Algorithm     = 'HS256'
                    SecretKey     = $secretKey
                    ExpectedToken = 'eyJhbGciOiJIUzI1NiIsImV4cCI6MTMwMDgxOTM4MH0.eyJhIjoiYiJ9.Pfvplu00vAoSuhS4JQ7sBUcN4nBUNseb2PDTJXqpObA'
                    ExtraHeader   = $header
                    Title         = 'Should return expected JWT token using HS256 algorithm and secret key with headers'
                }
                @{
                    Payload       = $payload
                    Algorithm     = 'HS384'
                    SecretKey     = $secretKey
                    ExpectedToken = 'eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9.eyJhIjoiYiJ9.AW7rys56-2Mqb5WErxivswynIFYOOZYm_2r-tY3HgoWOgvdg3dd3f6757a3sUtEK'
                    Title         = 'Should return expected JWT token using HS384 algorithm and secret key with no headers'
                }
                @{
                    Payload       = $payload
                    Algorithm     = 'HS384'
                    SecretKey     = $secretKey
                    ExpectedToken = 'eyJhbGciOiJIUzM4NCIsImV4cCI6MTMwMDgxOTM4MH0.eyJhIjoiYiJ9.xUNP90Pt_POh9NNK12h_FikZZnToKa5yo5a8tYpiaCUcT7f5ob7rezpfdAm3A0Ck'
                    ExtraHeader   = $header
                    Title         = 'Should return expected JWT token using HS384 algorithm and secret key with headers'
                }
                @{
                    Payload       = $payload
                    Algorithm     = 'HS512'
                    SecretKey     = $secretKey
                    ExpectedToken = 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhIjoiYiJ9.M-SylZTDUXqiL_4iuaJ-B0eUEevXygIoAs9_NsyKrSBUrsTzmUYSfUq0QoPlTt6iOclGFJn1E4_eRMcpoI5x1g'
                    Title         = 'Should return expected JWT token using HS512 algorithm and secret key with no headers'
                }
                @{
                    Payload       = $payload
                    Algorithm     = 'HS512'
                    SecretKey     = $secretKey
                    ExpectedToken = 'eyJhbGciOiJIUzUxMiIsImV4cCI6MTMwMDgxOTM4MH0.eyJhIjoiYiJ9.u-_coYrXkFjqdmasRWJWQJIRKbbHDS9lzOOKO30q-0ZzrNnVCC10CY8vUQPl0-darlxiFzCSB9bNiACTgN1Y0Q'
                    ExtraHeader   = $header
                    Title         = 'Should return expected JWT token using HS512 algorithm and secret key with headers'
                }
            ) {
                param($Payload, $Algorithm, $SecretKey, $ExpectedToken, $ExtraHeader)
                $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -SecretKey $SecretKey -ExtraHeader $ExtraHeader
            ($token | ConvertFrom-SecureString -AsPlainText) | Should -BeExactly $expectedToken
                $validToken = Test-JsonWebToken -Token $token -SecretKey $SecretKey -Algorithm $Algorithm
                $validToken | Should -BeTrue
            }
        }

        Context 'RS256 & RS384 & RS512' {

            It "<Title>" -TestCases @(
                @{
                    Payload         = $payload
                    Algorithm       = 'RS256'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS256', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhIjoiYiJ9.ZOxrVs28s77vMjjcUa-Bb11Q6ZRP1IEpl8Wqkkmxa8WXNWNMKfGKSopWfWr5t-_MWgaTyGbT40SlcwvWzoBsi0y20ESuw4_gHL8-AKx7NrkFONJudhUICf95cyKN6AgyU-KZj_oFK3kyRoPtn3IqCVKdBA8xqNJGj2K0RBVkbHOw5hIxKUAak5ZJ5BiXQrGj9FUeMdBJphKf-pFORLXVxTCACe6n0djCsjHFZiNbLRS2e7r2D-lC84ff6x4-8exe55-PXfsu7IyrAEw71oyfIa1WXeCs5QaTREJ6DmohDs1f0tne8HP7FwE-mbP0JAF5ujk_pEBXX9uqvsLvM_GmjQ'
                    Title           = 'Should return expected JWT token using RS256 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS256'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS256', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzI1NiIsImV4cCI6MTMwMDgxOTM4MH0.eyJhIjoiYiJ9.lvtcs4C6fwDBj_YaW53LOFsvqxfnRgMUEs6rUV6NUj3gMIfRlTmSoYDk8wpw-w4xKXCacSK0gh60T_iJkHu2lWGW9X6tmvfVQhWzdKnUWspLPYH3f3KDQYB6ZT4wmhEkK3nvNZHIE-DJkE0IRFm0R22Ux2CbgzU7niHoJVOzflIp1yM2X59GfkLMsfgDtt_3d55fewHfK1dJUMKX_QEwf0888FIp1s0idg5H-xzGMRJ_tvTpVMY1ASc21RJRrdAfPVYej7phPQom8qd_bjOqCgDYNIVylCIdz-a_5dbFJsq0z5U0vAQP0_UEADUKyxY3C7cqTzqkckVTBLgNOIl6Lw'
                    ExtraHeader     = $header
                    Title           = 'Should return expected JWT token using RS256 algorithm and certificate with headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS384'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS384', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzM4NCIsInR5cCI6IkpXVCJ9.eyJhIjoiYiJ9.B1zYb0RBU6KH4eXkv7jR3MOqcmM0f7H297lfK0-p8n95iYoW2-IDbPHSLzjCTt2W4wAgwVtZxjsGmDvUT9JooRTdWAb9DOekXAM90VBPM_VLV1JI_TcZNDmbMhrDHIhFu34KSMv_TPfzbxqkpPgmDxHKtRecajc9FrClICYAdYyqZ8NhHdpoxtyn_jHns0rbt0JZUxYnStHftmRD3imN5pfFqL14cpkGf7o3v61jXeRGu9pN_62Am9FrGOpodxNXLNRmDWQYv_EXeJu0o3iWiYAJD-P96ktrLIKYcd31X3s42FZcvFvL8tMxJia1Xs9x8keR8JZpbY4Pz-vO4xqGAi3lCitx4Q1HOzbpCoC0JaLx03r2uN4AlNjq8FZeVzSY5dFBLpJcj02ELr6QgKCXkXY32OGNBs6fVqa1EE3jPAncu-SI4702aQnhz84eIGnewlxEbnbluLLbQ-nOr55CRNhYdcpeX1i76_2Kp7A3P_HGlTJylBuHdtZ-kDvU_bYf'
                    Title           = 'Should return expected JWT token using RS384 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS384'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS384', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzM4NCIsImV4cCI6MTMwMDgxOTM4MH0.eyJhIjoiYiJ9.QNSAErGq5NQcMM_qG48c4VyFYnXkALp5cXsottAA-svVjTDglRM5L1fa8v8xQcH2-ef1Vcl0vexs3PPDzNsomo1DAijwNhqFH_vV9spGaUzAPGgwFkgA9F4gryJlfZotdx-f7-WJg4eAwyJ1-MNfkI4B7aLFnhXSlzNo6SbrcfGzXR4G71EbQvGz-ZD4Rj4C6zqyJ1SJ24XDnGEcH4aIVYysN0zzo4LrifNvNY-ZsGeIibTmMPvkyJosmP61YV6y0oeHciqUn2x84pbNKgm6KgMILYgFNFxwC3j1QrIYKJ-dhUU8U2rxTm_LZgaqkjJGkraQU_cLvwIbQ4zFSqbPZ2JGJZTrEdicMs1B83ymL98suA6_YiTwH1uMM6UtZDeYgBZhhdirkqo2UoP_lOdt12UinneyiQmzNxj9YZSJJWxzVTHFo0WSadqleM8QTk95-w6ciTa6RsZ3lrSytspA7K38gnNvxIp29_hTQjrFZFulC7777iD-vgDwP6ICRR8V'
                    ExtraHeader     = $header
                    Title           = 'Should return expected JWT token using RS384 algorithm and certificate with headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS512'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS512', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJhIjoiYiJ9.MTAlqVHm3xXIX7hcTgSvxPTFxZeCLTbt7sGOyw9jde7JRpVq_QNg6IfcsDNwrwvjY42sIXiq7eZa6L5AQ-HkZZ4GirgmcBQdEt1R44sY9rIdEhw_67K1fj2LnJB-n28fhJfXZsTZjcIBMTswLtAJMRhz56i7nXm4Fepy-bzqKtP841u5veQCeAlGYzsFqLAdxDnpzpgWlAyRx1Il835I5bnAZ6iGVeslpH5IbWymrrsOETLj8QxOHJrFXakoZVn980ug3zIMTMe3MmiD2ribHdUsEhMrVBcUlhaBHuV3cwCBx3Aw7curtOeoUWdA43zw4R9c-FCrWmKlDj5qcFCJfvZTUN-gO6pSUt1Gp-4E5XgkbjP4GcRvoPMwuwSFPqs-cZ3uyFBGI1hWxytx1Q7C1gR_XW6V6B0G9eCaekyfVOpDCswBpI_TOEFTV4fEym7RDyTQq1tvF0Jc74cVuHUncHG1GopVGlHHRCQJI4km1MjE6ArOpzF8S7HdCthkhMEsVvUpQs7jQBwFOlISSm1on8Rd1aQkZRhxddmipLQh8fQqK_oXhtWpnJNybMi5eThlD6mf1O7feX4K3C_b5xmaZi-FU_Gf4J8Z1Na1h9umXCH7c2uZ_NzpY10kFAwEPL3lFspc8pCzrafC4-fyc6L6na9cE7xvBO-XsCBc-vX8Pro'
                    Title           = 'Should return expected JWT token using RS512 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS512'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS512', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzUxMiIsImV4cCI6MTMwMDgxOTM4MH0.eyJhIjoiYiJ9.TfcwNV4WOcDLJ6bRYabyGOtWVSm3SGPNSdDyCIsiCvXaJKMHsvrB09mbJjuGF2uMYeQcJbwfP3Wd8-rBam2-I0tbbD8WHozAxPgVRnVZeCoUgurRgtgVZ1mtvAt40vt9aYWY0-s4UJj8W5_SoFL6EgOdNPvzyU9CdBU-r5R4o1UzK4_viBLQ8eSj828aVSJS2o4EHw_vUAYobxE0HR243qzCVr3Ob_OZ7uv9-igGXgbmFahqdtIJrioueU9cnER3VJbVEQFWMFxZL0HdJklGtov_DXFxfOJHrOXjEtG3nIpIfytbdErKYqJBtU-w22Zrb-KBHwAtL5Rw9apypce9iuL9xu6yG2_7tyEa_JrdGWtXyVm7TdBePAnzCskc-xHsz67E22lVgDGhyfo4_fx36Fjm8xPoELat3dk8XgFI3XAAdMnk2A92qmFEwfEN2Af0Bws3SInXP4rQ8-gPK9ycZ_p9OVaUQtesI4tlSEHpN4motZyh-HrsuzeiUuW2IsTbc2UpR2Cuf34B8YJyNKNAoRfcCBcxDreCbF5HLCOrumNX7czEmQ1kaIPXIFt4mqAW8S8IgG24L5v4632IF-GpkK72GfwBdY7Tq39wYfOKoYNh96lX0MmfYCxmrXG7pKEH2tr9fpWeUXrMXWKA1Q7FOwUlAFJFLlKYeIa9W3TJlkc'
                    ExtraHeader     = $header
                    Title           = 'Should return expected JWT token using RS512 algorithm and certificate with headers'
                }
            ) {
                param($Payload, $Algorithm, $CertificatePath, $ExpectedToken, $ExtraHeader)
                $x509Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertificatePath)
                $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -Certificate $x509Certificate -ExtraHeader $ExtraHeader
            ($token | ConvertFrom-SecureString -AsPlainText) | Should -BeExactly $ExpectedToken
                $validToken = Test-JsonWebToken -Token $token -Certificate $x509Certificate -Algorithm $Algorithm
                $validToken | Should -BeTrue
            }
        }

        Context 'ES256 & ES384 & ES512' {

            It "<Title>" -TestCases @(
                @{
                    Payload         = $payload
                    Algorithm       = 'ES256'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES256', 'certificate.pfx')
                    Title           = 'Should return a valid JWT token using ES256 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES256'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES256', 'certificate.pfx')
                    ExtraHeader     = $header
                    Title           = 'Should return a valid JWT token using ES256 algorithm and certificate with headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES384'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES384', 'certificate.pfx')
                    Title           = 'Should return a valid JWT token using ES384 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES384'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES384', 'certificate.pfx')
                    ExtraHeader     = $header
                    Title           = 'Should return a valid JWT token using ES384 algorithm and certificate with headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES512'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES512', 'certificate.pfx')
                    Title           = 'Should return a valid JWT token using ES512 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES512'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES512', 'certificate.pfx')
                    ExtraHeader     = $header
                    Title           = 'Should return a valid JWT token using ES512 algorithm and certificate with headers'
                }
            ) {
                param($Payload, $Algorithm, $CertificatePath, $ExtraHeader)
                $x509Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertificatePath)

                # ES* family algorithms do not give a deterministic JWT token due to ECDSA probabilistic algorithm, so we can just decode and check its correct
                $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -Certificate $x509Certificate -ExtraHeader $ExtraHeader
                $validToken = Test-JsonWebToken -Token $token -Certificate $x509Certificate -Algorithm $Algorithm
                $validToken | Should -BeTrue
            }
        }

        Context 'None' {

            It 'Should return valid JWT token using none algorithm without headers and output warning' {
                $token = New-JsonWebToken -Payload $payload -Algorithm 'none' -WarningVariable warning1 -WarningAction SilentlyContinue
                $validToken = Test-JsonWebToken -Token $token -Algorithm 'none' -WarningVariable warning2 -WarningAction SilentlyContinue
                $validToken | Should -BeTrue
                $warning1 | Should -HaveCount 1
                $warning2 | Should -HaveCount 1
            }

            It 'Should return valid JWT token using none algorithm with headers output warning' {
                $token = New-JsonWebToken -Payload $payload -Algorithm 'none' -ExtraHeader $headers -WarningVariable warning1 -WarningAction SilentlyContinue
                $validToken = Test-JsonWebToken -Token $token -Algorithm 'none' -WarningVariable warning2 -WarningAction SilentlyContinue
                $validToken | Should -BeTrue
                $warning1 | Should -HaveCount 1
                $warning2 | Should -HaveCount 1
            }
        }
    }

    Context 'JWT Encryption' {

        BeforeAll {
            $AESCBCHMACAndGCMSecretKey = @{
                'DIR' = @{
                    'A128CBC_HS256' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A192CBC_HS384' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 48 | ForEach-Object { [char]$_ }) -join ''
                    'A256CBC_HS512' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 64 | ForEach-Object { [char]$_ }) -join ''
                    'A128GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A192GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A256GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                }
            }

            $AESKeyWrapSecretKey = @{
                'A128KW' = @{
                    'A128CBC_HS256' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A192CBC_HS384' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A256CBC_HS512' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A128GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A192GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A256GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                }
                'A192KW' = @{
                    'A128CBC_HS256' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A192CBC_HS384' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A256CBC_HS512' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A128GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A192GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A256GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                }
                'A256KW' = @{
                    'A128CBC_HS256' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A192CBC_HS384' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A256CBC_HS512' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A128GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A192GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A256GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                }
            }

            $AESGCMKeyWrapSecretKey = @{
                'A128GCMKW' = @{
                    'A128CBC_HS256' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A192CBC_HS384' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A256CBC_HS512' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A128GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A192GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                    'A256GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                }
                'A192GCMKW' = @{
                    'A128CBC_HS256' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A192CBC_HS384' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A256CBC_HS512' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A128GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A192GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                    'A256GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                }
                'A256GCMKW' = @{
                    'A128CBC_HS256' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A192CBC_HS384' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A256CBC_HS512' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A128GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A192GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                    'A256GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                }
            }

            $PBES2HMACSecretKey = @{
                'A128CBC_HS256' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
                'A192CBC_HS384' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 48 | ForEach-Object { [char]$_ }) -join ''
                'A256CBC_HS512' = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 64 | ForEach-Object { [char]$_ }) -join ''
                'A128GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) -join ''
                'A192GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 24 | ForEach-Object { [char]$_ }) -join ''
                'A256GCM'       = ((0x29..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) -join ''
            }
        }

        Context 'RSA_OAEP_256 & RSA_OAEP & RSA1_5' {
            It "<Title>" -TestCases @(
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA_OAEP_256'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.pfx')
                    Title           = "Should return a valid JWT token using RSA_OAEP_256 algorithm and '$encryptions' encryption and certificate with no headers"
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA_OAEP_256'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.pfx')
                    Title           = "Should return a valid JWT token using RSA_OAEP_256 algorithm and '$encryptions' encryption and certificate with headers"
                    ExtraHeader     = $headers
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA_OAEP'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.pfx')
                    Title           = "Should return a valid JWT token using RSA_OAEP algorithm and '$encryptions' encryption and certificate with no headers"
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA_OAEP'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.pfx')
                    Title           = "Should return a valid JWT token using RSA_OAEP algorithm and '$encryptions' encryption and certificate with headers"
                    ExtraHeader     = $headers
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA1_5'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.pfx')
                    Title           = "Should return a valid JWT token using RSA1_5 algorithm and '$encryptions' encryption and certificate with no headers"
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA1_5'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.pfx')
                    Title           = "Should return a valid JWT token using RSA1_5 algorithm and '$encryptions' encryption and certificate with headers"
                    ExtraHeader     = $headers
                }
            ) {
                param($Payload, $Algorithm, $Encryption, $CertificatePath, $Title, $ExtraHeader)

                $x509Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertificatePath)

                foreach ($enc in $Encryption) {
                    $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -Encryption $enc -Certificate $x509Certificate
                    $validToken = Test-JsonWebToken -Token $token -Certificate $x509Certificate -Algorithm $Algorithm -Encryption $enc
                    $validToken | Should -BeTrue
                }
            }
        }

        Context 'DIR' {
            It "<Title>" -TestCases @(
                @{
                    Payload    = $payload
                    Algorithm  = 'DIR'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using DIR algorithm and '$encryptions' encryption and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'DIR'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using DIR algorithm and '$encryptions' encryption and secret key with headers"
                }
            ) {
                param($Payload, $Algorithm, $Encryption, $SecretKey, $ExtraHeader)

                foreach ($enc in $Encryption) {
                    $SecretKey = $AESCBCHMACAndGCMSecretKey[$Algorithm][$enc] | ConvertTo-SecureString -AsPlainText -Force
                    $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -Encryption $enc -SecretKey $SecretKey -ExtraHeader $ExtraHeader
                    $validToken = Test-JsonWebToken -Token $token -SecretKey $SecretKey -Algorithm $Algorithm -Encryption $enc
                    $validToken | Should -BeTrue
                }
            }
        }

        Context 'A128KW & A192KW & A256KW' {
            It "<Title>" -TestCases @(
                @{
                    Payload    = $payload
                    Algorithm  = 'A128KW'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using A128KW algorithm and '$encryptions' encryptions and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'A128KW'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using A128KW algorithm and '$encryptions' encryptions and secret key with headers"
                }
                @{
                    Payload    = $payload
                    Algorithm  = 'A192KW'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using A192KW algorithm and '$encryptions' encryptions and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'A192KW'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using A192KW algorithm and '$encryptions' encryptions and secret key with headers"
                }
                @{
                    Payload    = $payload
                    Algorithm  = 'A256KW'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using A256KW algorithm and '$encryptions' encryptions and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'A256KW'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using A256KW algorithm and '$encryptions' encryptions and secret key with headers"
                }
            ) {
                param($Payload, $Algorithm, $Encryption, $SecretKey, $ExtraHeader)

                foreach ($enc in $Encryption) {
                    $SecretKey = $AESKeyWrapSecretKey[$Algorithm][$enc] | ConvertTo-SecureString -AsPlainText -Force
                    $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -Encryption $enc -SecretKey $SecretKey -ExtraHeader $ExtraHeader
                    $validToken = Test-JsonWebToken -Token $token -SecretKey $SecretKey -Algorithm $Algorithm -Encryption $enc
                    $validToken | Should -BeTrue
                }
            }
        }

        Context 'A128GCMKW & A192GCMKW & A256GCMKW' {
            It "<Title>" -TestCases @(
                @{
                    Payload    = $payload
                    Algorithm  = 'A128GCMKW'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using A128GCMKW algorithm and '$encryptions' encryptions and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'A128GCMKW'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using A128GCMKW algorithm and '$encryptions' encryptions and secret key with headers"
                }
                @{
                    Payload    = $payload
                    Algorithm  = 'A192GCMKW'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using A192GCMKW algorithm and '$encryptions' encryptions and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'A192GCMKW'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using A192GCMKW algorithm and '$encryptions' encryptions and secret key with headers"
                }
                @{
                    Payload    = $payload
                    Algorithm  = 'A256GCMKW'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using A256GCMKW algorithm and '$encryptions' encryptions and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'A256GCMKW'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using A256GCMKW algorithm and '$encryptions' encryptions and secret key with headers"
                }
            ) {
                param($Payload, $Algorithm, $Encryption, $SecretKey, $ExtraHeader)

                foreach ($enc in $Encryption) {
                    $SecretKey = $AESGCMKeyWrapSecretKey[$Algorithm][$enc] | ConvertTo-SecureString -AsPlainText -Force
                    $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -Encryption $enc -SecretKey $SecretKey -ExtraHeader $ExtraHeader
                    $validToken = Test-JsonWebToken -Token $token -SecretKey $SecretKey -Algorithm $Algorithm -Encryption $enc
                    $validToken | Should -BeTrue
                }
            }
        }

        Context 'PBES2_HS256_A128KW & PBES2_HS384_A192KW & PBES2_HS512_A256KW' {
            It "<Title>" -TestCases @(
                @{
                    Payload    = $payload
                    Algorithm  = 'PBES2_HS256_A128KW'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using PBES2_HS256_A128KW algorithm and '$encryptions' encryptions and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'PBES2_HS256_A128KW'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using PBES2_HS256_A128KW algorithm and '$encryptions' encryptions and secret key with headers"
                }
                @{
                    Payload    = $payload
                    Algorithm  = 'PBES2_HS384_A192KW'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using PBES2_HS384_A192KW algorithm and '$encryptions' encryptions and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'PBES2_HS384_A192KW'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using PBES2_HS384_A192KW algorithm and '$encryptions' encryptions and secret key with headers"
                }
                @{
                    Payload    = $payload
                    Algorithm  = 'PBES2_HS512_A256KW'
                    Encryption = $encryptions
                    Title      = "Should return expected JWT token using PBES2_HS512_A256KW algorithm and '$encryptions' encryptions and secret key with no headers"
                }
                @{
                    Payload     = $payload
                    Algorithm   = 'PBES2_HS512_A256KW'
                    Encryption  = $encryptions
                    ExtraHeader = $header
                    Title       = "Should return expected JWT token using PBES2_HS512_A256KW algorithm and '$encryptions' encryptions and secret key with headers"
                }
            ) {
                param($Payload, $Algorithm, $Encryption, $SecretKey, $ExtraHeader)

                foreach ($enc in $Encryption) {
                    $SecretKey = $PBES2HMACSecretKey[$enc] | ConvertTo-SecureString -AsPlainText -Force
                    $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -Encryption $enc -SecretKey $SecretKey -ExtraHeader $ExtraHeader
                    $validToken = Test-JsonWebToken -Token $token -SecretKey $SecretKey -Algorithm $Algorithm -Encryption $enc
                    $validToken | Should -BeTrue
                }
            }
        }
    }

    Context 'Invalid Parameter Combinations' {
        BeforeAll {
            $payload = @{ 'a' = 'b' }
            $secretKey = 'abc' | ConvertTo-SecureString -AsPlainText -Force
            $certificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS256', 'certificate.p12')
            $x509Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificatePath)
            $token = 'abc123' | ConvertTo-SecureString -AsPlainText -Force
        }

        It 'Should throw an exception if incompatible algorithm RS256 is used with -SecretKey' {
            { New-JsonWebToken -Payload $payload -Algorithm 'RS256' -SecretKey $secretKey }
            | Should -Throw -ErrorId 'SecretRequiredJwsAlgorithms,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'

            { Test-JsonWebToken -Token $token -Algorithm 'RS256' -SecretKey $secretKey }
            | Should -Throw -ErrorId 'SecretRequiredJwsAlgorithms,PoshJsonWebToken.Commands.TestJsonWebTokenCommand'
        }

        It 'Should throw an exception if incompatible algorithm HS256 is used with -Certificate' {
            { New-JsonWebToken -Payload $payload -Algorithm 'HS256' -Certificate $x509Certificate }
            | Should -Throw -ErrorId 'CertificateRequiredJwsAlgorithms,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'

            { Test-JsonWebToken -Token $token -Algorithm 'HS256' -Certificate $x509Certificate }
            | Should -Throw -ErrorId 'CertificateRequiredJwsAlgorithms,PoshJsonWebToken.Commands.TestJsonWebTokenCommand'
        }

        It 'Should throw an exception if algorithm is used without -SecretKey or -Certificate parameter' {
            { New-JsonWebToken -Payload $payload -Algorithm 'HS256' }
            | Should -Throw -ErrorId 'JwsAlgorithmRequiresKey,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'

            { Test-JsonWebToken -Token $token -Algorithm 'HS256' }
            | Should -Throw -ErrorId 'JwsAlgorithmRequiresKey,PoshJsonWebToken.Commands.TestJsonWebTokenCommand'
        }

        It 'Should throw an exception if algorithm is invalid' {
            { New-JsonWebToken -Payload $payload -Algorithm 'Invalid' }
            | Should -Throw -ErrorId 'InvalidAlgorithm,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'

            { Test-JsonWebToken -Token $token -Algorithm 'Invalid' }
            | Should -Throw -ErrorId 'InvalidAlgorithm,PoshJsonWebToken.Commands.TestJsonWebTokenCommand'
        }

        It "Should throw an exception if '<Algorithm>' algorithm is used" -TestCases @(
            @{ Algorithm = 'PS256' }
            @{ Algorithm = 'PS384' }
            @{ Algorithm = 'PS512' }
            @{ Algorithm = 'ECDH_ES' }
            @{ Algorithm = 'ECDH_ES_A128KW' }
            @{ Algorithm = 'ECDH_ES_A192KW' }
            @{ Algorithm = 'ECDH_ES_A256KW' }
        ) {
            param($Algorithm)

            { New-JsonWebToken -Payload $payload -Algorithm $Algorithm }
            | Should -Throw -ErrorId 'InvalidAlgorithm,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'

            { Test-JsonWebToken -Token $token -Algorithm $Algorithm }
            | Should -Throw -ErrorId 'InvalidAlgorithm,PoshJsonWebToken.Commands.TestJsonWebTokenCommand'
        }

        It 'Should throw an exception if JWS algorithm is using -Encryption parameter' {
            { New-JsonWebToken -Payload $payload -Algorithm 'RS256' -Encryption 'A128CBC_HS256' -Certificate $x509Certificate }
            | Should -Throw -ErrorId 'JweEncryptionRequiredWithJweAlgorithm,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'

            { Test-JsonWebToken -Token $token -Algorithm 'RS256' -Encryption 'A128CBC_HS256' -Certificate $x509Certificate }
            | Should -Throw -ErrorId 'JweEncryptionRequiredWithJweAlgorithm,PoshJsonWebToken.Commands.TestJsonWebTokenCommand'
        }

        It 'Should throw an exception if JWE algorithm is not using -Encryption parameter' {
            { New-JsonWebToken -Payload $payload -Algorithm 'RSA_OAEP_256' -Certificate $x509Certificate }
            | Should -Throw -ErrorId 'InvalidJweEncryption,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'

            { Test-JsonWebToken -Token $token -Algorithm 'RSA_OAEP_256' -Certificate $x509Certificate }
            | Should -Throw -ErrorId 'InvalidJweEncryption,PoshJsonWebToken.Commands.TestJsonWebTokenCommand'
        }

        It 'Should throw an exception if incompatible algorithm RSA_OAEP_256 with encryption A128CBC_HS256 is used with -SecretKey' {
            { New-JsonWebToken -Payload $payload -Algorithm 'RSA_OAEP_256' -Encryption 'A128CBC_HS256' -SecretKey $secretKey }
            | Should -Throw -ErrorId 'SecretRequiredJweAlgorithms,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'

            { Test-JsonWebToken -Token $token -Algorithm 'RSA_OAEP_256' -Encryption 'A128CBC_HS256' -SecretKey $secretKey }
            | Should -Throw -ErrorId 'SecretRequiredJweAlgorithms,PoshJsonWebToken.Commands.TestJsonWebTokenCommand'
        }

        It 'Should throw an exception if incompatible algorithm DIR with encryption A128CBC_HS256 is used with -Certificate' {
            { New-JsonWebToken -Payload $payload -Algorithm 'DIR' -Encryption 'A128CBC_HS256' -Certificate $x509Certificate }
            | Should -Throw -ErrorId 'CertificateRequiredJweAlgorithms,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'

            { Test-JsonWebToken -Token $token -Algorithm 'DIR' -Encryption 'A128CBC_HS256' -Certificate $x509Certificate }
            | Should -Throw -ErrorId 'CertificateRequiredJweAlgorithms,PoshJsonWebToken.Commands.TestJsonWebTokenCommand'
        }
    }
}
