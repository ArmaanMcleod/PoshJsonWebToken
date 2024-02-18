Describe 'JsonWebToken Tests' {

    BeforeDiscovery {
        $payload = @{ 'a' = 'b' }
        $header = @{ 'exp' = 1300819380 }
        $secretKey = 'abc' | ConvertTo-SecureString -AsPlainText -Force
        $encryptions = 'A128CBC_HS256', 'A192CBC_HS384', 'A256CBC_HS512', 'A128GCM', 'A192GCM', 'A256GCM'

        $repoPath = (Get-Item -Path $PSScriptRoot).Parent.FullName
        $modulePath = Join-Path -Path $repoPath -ChildPath 'out' -AdditionalChildPath 'PoshJsonWebToken'
        Import-Module $modulePath -Force;
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
                    ExpectedToken   = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhIjoiYiJ9.o0Ev0bNv25LrU3fNZdpIte5GbLkfLhT3YeDCfmsLcTXtT012ZC97ffB_fYfDsKmvOgVIPyj5X3XykjZlnsPBuhH74vKHHyoFEkBrZ5w2-yqa_9m20sYrL59msnyEVEe0u6xmh8AApGshOkXH7SAm25zz5FFg2Svu6LuFhw8JVs4iUhz6TrblkKtHCF0aOLRYjOuOwdWbx9BTJCo8mtheZ6meQgFUqIqJCmlSRIqGeBUZD8N0h5_c3rBgItJeMsqe7RrPvD4JER6RmFuk6rkJEG7cDMqXsOloUyry-TCfYIumpqwwdOfFrpq66nGG_HYD9I-dv4KDskFylUxpk2Y5Cw'
                    Title           = 'Should return expected JWT token using RS256 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS256'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS256', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzI1NiIsImV4cCI6MTMwMDgxOTM4MH0.eyJhIjoiYiJ9.HTTVo-HPI8CIswW8oVnNX7ZXPV1ZwlmcpXvQAySEZPnaolf8RXcHDdkJOeYAZhZHDXxe0wuw8N_a2Fg2bsHBR0TeSpR0hEafA8xNV3i0JlWdQ5luqMbplNk3h5oIAckTm3duuH_cLA2kKg3J9ymQPYoVkm-hX2PKI2I0euR_E4CmXu54AnAat86TJJDSWxPuyPISHgaGF9w5af1jbmrR4pMylZHVmLemySmwmC_emuTxaAfvySGryKr3TiHQIcrCjCTQboGuaGkH6Jk5J-dQgb_yynQ3TzRonqyfixu0bGlxKL9LcNS-G8AM1P8QoLTLGJIGVL_f-kR2DUDL7WHJiw'
                    ExtraHeader     = $header
                    Title           = 'Should return expected JWT token using RS256 algorithm and certificate with headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS384'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS384', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzM4NCIsInR5cCI6IkpXVCJ9.eyJhIjoiYiJ9.fLslEXEGZK-lO9bCxvICXsmkBypPC0axCZXcZAYfmGJKYXp0CdtLGO-fmVqlchBLysd14VT5cYbcKMNaJzSZuXt0hauxQ1vX9DNRE1MrxYMKTQqWoUA_khzG2RGInGhAk9gAp5Mih5IJfV7SVfawh5B7Ls62gi0BbS0eYzuPvxU_sr8nDTHVafw2pR3OaTscP8w4gb3m30L3VFI7ITCqqYh1lQqFq075YqX99aAvRBdJ5sVAC-XBmd-Nez1Lsa4bNRtMPUjGTviKqlPef3p2wx90xdzVBceujPOpzQbU10eqX8pJELmW5meBDhtUNmDjkRXDfPY5sCo4pohoLKojXA_zLH9YFYOBb6sejEn0Uiml2tb4Ka7LVyvcFiGi_IQuRDOxXy42O6YR8UvDrOaE339iJh2Ewtf1wvf_6iir2_83pypvm01BbKnwJE3UNLPE2sFARP9WZQnLhrzuq0tM0QMhxqo-YIVu1b5IOB1Fyu-EQASEtfCOAUETT2vEfO9U'
                    Title           = 'Should return expected JWT token using RS384 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS384'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS384', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzM4NCIsImV4cCI6MTMwMDgxOTM4MH0.eyJhIjoiYiJ9.bHj8xp1no5QLGSLh2Mg8ne1CUFQ2UkRtzYQ_nyyNBd_2xr7xQt8RAzPH6KyI4hpagXYrzJGVZPrAR38JKUzyuZDftieD09uOlQkAodyapptQdE5PUR5BQYQNl9CZaEOD2YgXpy4uVywaFeF4EbzMmlY4tmVm8o94onL7u3EcaS4uGqAHTEAuoxdH8YzZRYAk7K-1Bx9rzRcbBYde7ByM_o5-3q_JKgPgwknsDdBXCNpRaERurBiFRJDSqp3idqdAEM4vI6wHbhm0is0aQEyOCjUUmRHduRyJ7VhXgJ7_CYpUYKX9jkBiwkgOZ14C1mq1d1WSkxEBAFslo0owzwL2gJu2To5C2_q6oJL6ORvBVyMA5kM8P7cA-NjrlNiqAU3HUJtZRO8P1v2elcH3TYFSOJ_lKr7KeyS0qZhKdFtnxGGyXl-KLDCiyKbdr_ici6tJjX5aelmY5q8uY9AUrUhwd8jb6aEjUp3sHFi9RV9GK08jsPZ-LsCwhPVx2FmJTZZ9'
                    ExtraHeader     = $header
                    Title           = 'Should return expected JWT token using RS384 algorithm and certificate with headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS512'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS512', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJhIjoiYiJ9.QI0DnCPemeAi2yD8YXuMUBlVk06HSwkliITgkwHlO22XF11akEMVU04YI_ZofIy2zO3MN5xO6wVP67iJao-jJCxq7Fj88ieKkCGQKBjZXf8vyq0GFs4jsNFRhgOzRJ6oxAGfB6XQE3MiQv_P2Ts6rfr11SgYz4BPIRmJZbQ2GIS0ciDpmn8HxCKEcmf9n-ksIVwarWvlbRmjFmPHMA_oAJHihNflCtNuEJtsIwlpHLzsNOgqEojTOU030SFmLX3_-iUOU-qEEnOOGd2CW47IpxS7yn9CsIL2xiNOWg_0iYvoouimvGNFd54WlPc68hNudiOE1z8AxnZHTTeob2ZgVlOpMw3xC0hBR599SFfsNSDNlZoF2ffkOjHozd-1qbjvSno83nVRCYHNcN6sC2eOrxrD-BjZJmCE38Plvr66xe0JAK9csXfAjFtDxRxbmbhQ3zYhK03jXf0seOKQQO7cRC_EkMvbJYB31aqxeTxL24o7Id1xjT8MZSXVBfQMagV5g4GkTvB8VEnVfaMuUKZcvoUp5EkQuk8IHwKqTfsQjiI0N4QxO4VYe9Y0C4hEpoPBnGLV_6CqF8_jz282--O0VWMWEoQNyDHMh9I7up11DHNxLhYzit-e0qGtE1CZTbSBaM72ycpYxfNL_TSKtOKgD9bCZXy-EIWpNzLvYbp42j8'
                    Title           = 'Should return expected JWT token using RS512 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RS512'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RS512', 'certificate.p12')
                    ExpectedToken   = 'eyJhbGciOiJSUzUxMiIsImV4cCI6MTMwMDgxOTM4MH0.eyJhIjoiYiJ9.HHc1SwlDbPBeTQP7OduZg3hUn7LpoClY7-VhJtZuQI2FheYQD4efTbyIjTdIS0xXbu3V00_X-u0NDLpG63UHICAmyZRRKILeiA70qXHC4CtSXMEPncPS08e_QQDjQM2QHI6RMM5nR-BIsPRrKk1qGgHWpqlmDTLIbsHEUQlsplkFB4J1sHutMwmfY6aiTs0Bsqg0i4HerpfumMZ2r8tCfgZhhU-iNK2ni2mREmQJom_apyIosoeontXvPrcj0QdwiwjEsYk8H_tW9cA8jOubADE_vyT9UPeRwwko9PJLx6TwzZV3UAustng99iBLn8Vgbxc8oPtMt80nF5P8-3hmmiR2BsmtQrVN6G_Z6dvq6_UoComRkSH-Xd_2UWnqoTlUkmlm-CbqEvGE784rrTM7i6H_04eNkiEdATlw2Ad_SH6Q2encaIoRZtf9OQWU9Op_9yFp3v_F3hOIiSHTvGwSmH2UAddQFYcmubI4a_WAzFM3njiikUqlx6cjFgrvKriUy2kxaLK-ZQN2S3HT2XnOSYFQ_yXnYyBFV_rh9Yyp8ED8jfb2H0kR0jvE2qmY_2-XLDiNqqWPvTDBgciZ9hwGJbrzMw0tp_hD1_sHkyz9-hKzC2m3BbK6uckvhaHrV979JyA6hGvIwW__zVJ2tYaXUjbD2bjk3W_N5qye-qM3REg'
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
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES256', 'certificate.p12')
                    Title           = 'Should return a valid JWT token using ES256 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES256'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES256', 'certificate.p12')
                    ExtraHeader     = $header
                    Title           = 'Should return a valid JWT token using ES256 algorithm and certificate with headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES384'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES384', 'certificate.p12')
                    Title           = 'Should return a valid JWT token using ES384 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES384'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES384', 'certificate.p12')
                    ExtraHeader     = $header
                    Title           = 'Should return a valid JWT token using ES384 algorithm and certificate with headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES512'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES512', 'certificate.p12')
                    Title           = 'Should return a valid JWT token using ES512 algorithm and certificate with no headers'
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'ES512'
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'ES512', 'certificate.p12')
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
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.p12')
                    Title           = "Should return a valid JWT token using RSA_OAEP_256 algorithm and '$encryptions' encryption and certificate with no headers"
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA_OAEP_256'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.p12')
                    Title           = "Should return a valid JWT token using RSA_OAEP_256 algorithm and '$encryptions' encryption and certificate with headers"
                    ExtraHeader     = $headers
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA_OAEP'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.p12')
                    Title           = "Should return a valid JWT token using RSA_OAEP algorithm and '$encryptions' encryption and certificate with no headers"
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA_OAEP'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.p12')
                    Title           = "Should return a valid JWT token using RSA_OAEP algorithm and '$encryptions' encryption and certificate with headers"
                    ExtraHeader     = $headers
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA1_5'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.p12')
                    Title           = "Should return a valid JWT token using RSA1_5 algorithm and '$encryptions' encryption and certificate with no headers"
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA1_5'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.p12')
                    Title           = "Should return a valid JWT token using RSA1_5 algorithm and '$encryptions' encryption and certificate with headers"
                    ExtraHeader     = $headers
                }
            ) {
                param($Payload, $Algorithm, $Encryption, $CertificatePath, $Title, $ExtraHeader)

                $x509Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertificatePath)

                foreach ($enc in $Encryption) {
                    $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -Encryption $enc -Certificate $x509Certificate -ExtraHeader $ExtraHeader
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

        Context 'DEF' {
            It "<Title>" -TestCases @(
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA_OAEP_256'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.p12')
                    Title           = "Should return a valid JWT token using RSA_OAEP_256 algorithm and '$encryptions' encryption and DEFLATE compression and certificate"
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA_OAEP'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.p12')
                    Title           = "Should return a valid JWT token using RSA_OAEP algorithm and '$encryptions' encryption and DEFLATE compression and certificate"
                    Compression     = $true
                }
                @{
                    Payload         = $payload
                    Algorithm       = 'RSA1_5'
                    Encryption      = $encryptions
                    CertificatePath = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Certificates' -AdditionalChildPath 'RSA', 'certificate.p12')
                    Title           = "Should return a valid JWT token using RSA1_5 algorithm and '$encryptions' encryption and DEFLATE compression and certificate"
                    Compression     = $true
                }
            ) {
                param($Payload, $Algorithm, $Encryption, $CertificatePath, $Title, $Compression)

                $x509Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertificatePath)

                foreach ($enc in $Encryption) {
                    $token = New-JsonWebToken -Payload $Payload -Algorithm $Algorithm -Encryption $enc -Certificate $x509Certificate -Compression:$Compression
                    $validToken = Test-JsonWebToken -Token $token -Certificate $x509Certificate -Algorithm $Algorithm -Encryption $enc
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

        It 'Should throw an exception if compression used with JWE algorithm' {
            { New-JsonWebToken -Payload $payload -Algorithm 'RS256' -SecretKey $secretKey -Compression }
            | Should -Throw -ErrorId 'CompressionRequiresJweEncryption,PoshJsonWebToken.Commands.NewJsonWebTokenCommand'
        }
    }

    Context 'Parameter argument completion' {
        BeforeDiscovery {
            $allAlgorithms = 'none', 'HS256', 'HS384', 'HS512', 'RS256', 'RS384', 'RS512', 'ES256', 'ES384', 'ES512', 'RSA1_5', 'RSA_OAEP', 'RSA_OAEP_256', 'DIR', 'A128KW', 'A192KW', 'A256KW', 'PBES2_HS256_A128KW', 'PBES2_HS384_A192KW', 'PBES2_HS512_A256KW', 'A128GCMKW', 'A192GCMKW', 'A256GCMKW'
            $hmacAlgorithms = 'HS256', 'HS384', 'HS512'
            $ecdsaAlgorithms = 'ES256', 'ES384', 'ES512'
            $aesAlgorithms = 'A128KW', 'A192KW', 'A256KW', 'A128GCMKW', 'A192GCMKW', 'A256GCMKW'
            $aes128Algorithms = 'A128KW', 'A128GCMKW'
            $pbes2Algorithm = 'PBES2_HS256_A128KW'

            $allEncryptions = 'A128CBC_HS256', 'A192CBC_HS384', 'A256CBC_HS512', 'A128GCM', 'A192GCM', 'A256GCM'
            $aes128Encryptions = 'A128CBC_HS256', 'A128GCM'
            $aes256HmacEncryption = 'A256CBC_HS512'

            function JoinStringsWithSingleQuote {
                param($strings)
                $strings.Split() | ForEach-Object { "'$_'" } | Join-String -Separator ' '
            }
        }

        Context '-Algorithm parameter' {
            It "Should complete Algorithm for '<TextInput>'" -TestCases @(

                # Without Quotes
                @{ TextInput = "New-JsonWebToken -Algorithm "; ExpectedAlgorithms = $allAlgorithms -join ' ' }
                @{ TextInput = "Test-JsonWebToken -Algorithm "; ExpectedAlgorithms = $allAlgorithms -join ' ' }
                @{ TextInput = "New-JsonWebToken -Algorithm HS"; ExpectedAlgorithms = $hmacAlgorithms -join ' ' }
                @{ TextInput = "Test-JsonWebToken -Algorithm HS"; ExpectedAlgorithms = $hmacAlgorithms -join ' ' }
                @{ TextInput = "New-JsonWebToken -Algorithm ES"; ExpectedAlgorithms = $ecdsaAlgorithms -join ' ' }
                @{ TextInput = "Test-JsonWebToken -Algorithm ES"; ExpectedAlgorithms = $ecdsaAlgorithms -join ' ' }
                @{ TextInput = "New-JsonWebToken -Algorithm A"; ExpectedAlgorithms = $aesAlgorithms -join ' ' }
                @{ TextInput = "Test-JsonWebToken -Algorithm A"; ExpectedAlgorithms = $aesAlgorithms -join ' ' }
                @{ TextInput = "New-JsonWebToken -Algorithm A128"; ExpectedAlgorithms = $aes128Algorithms -join ' ' }
                @{ TextInput = "Test-JsonWebToken -Algorithm A128"; ExpectedAlgorithms = $aes128Algorithms -join ' ' }
                @{ TextInput = "New-JsonWebToken -Algorithm PBES2_HS256"; ExpectedAlgorithms = $pbes2Algorithm -join ' ' }
                @{ TextInput = "Test-JsonWebToken -Algorithm PBES2_HS256"; ExpectedAlgorithms = $pbes2Algorithm -join ' ' }

                # With Quotes
                @{ TextInput = "New-JsonWebToken -Algorithm '"; ExpectedAlgorithms = JoinStringsWithSingleQuote $allAlgorithms }
                @{ TextInput = "Test-JsonWebToken -Algorithm '"; ExpectedAlgorithms = JoinStringsWithSingleQuote $allAlgorithms }
                @{ TextInput = "New-JsonWebToken -Algorithm 'HS"; ExpectedAlgorithms = JoinStringsWithSingleQuote $hmacAlgorithms }
                @{ TextInput = "Test-JsonWebToken -Algorithm 'HS"; ExpectedAlgorithms = JoinStringsWithSingleQuote $hmacAlgorithms }
                @{ TextInput = "New-JsonWebToken -Algorithm 'ES"; ExpectedAlgorithms = JoinStringsWithSingleQuote $ecdsaAlgorithms }
                @{ TextInput = "Test-JsonWebToken -Algorithm 'ES"; ExpectedAlgorithms = JoinStringsWithSingleQuote $ecdsaAlgorithms }
                @{ TextInput = "New-JsonWebToken -Algorithm 'A"; ExpectedAlgorithms = JoinStringsWithSingleQuote $aesAlgorithms }
                @{ TextInput = "Test-JsonWebToken -Algorithm 'A"; ExpectedAlgorithms = JoinStringsWithSingleQuote $aesAlgorithms }
                @{ TextInput = "New-JsonWebToken -Algorithm 'A128"; ExpectedAlgorithms = JoinStringsWithSingleQuote $aes128Algorithms }
                @{ TextInput = "Test-JsonWebToken -Algorithm 'A128"; ExpectedAlgorithms = JoinStringsWithSingleQuote $aes128Algorithms }
                @{ TextInput = "New-JsonWebToken -Algorithm 'PBES2_HS256"; ExpectedAlgorithms = JoinStringsWithSingleQuote $pbes2Algorithm }
                @{ TextInput = "Test-JsonWebToken -Algorithm 'PBES2_HS256"; ExpectedAlgorithms = JoinStringsWithSingleQuote $pbes2Algorithm }

            ) {
                param($TextInput, $ExpectedAlgorithms)
                $res = TabExpansion2 -inputScript $TextInput -cursorColumn $TextInput.Length
                $completionText = $res.CompletionMatches.CompletionText
                $completionText -join ' ' | Should -BeExactly $ExpectedAlgorithms
            }
        }

        Context '-Encryption parameter' {
            It "Should complete Algorithm for '<TextInput>'" -TestCases @(

                # Without Quotes
                @{ TextInput = "New-JsonWebToken -Encryption "; ExpectedAlgorithms = $allEncryptions -join ' ' }
                @{ TextInput = "Test-JsonWebToken -Encryption "; ExpectedAlgorithms = $allEncryptions -join ' ' }
                @{ TextInput = "New-JsonWebToken -Encryption A128"; ExpectedAlgorithms = $aes128Encryptions -join ' ' }
                @{ TextInput = "Test-JsonWebToken -Encryption A128"; ExpectedAlgorithms = $aes128Encryptions -join ' ' }
                @{ TextInput = "New-JsonWebToken -Encryption A256CBC_HS"; ExpectedAlgorithms = $aes256HmacEncryption -join ' ' }
                @{ TextInput = "Test-JsonWebToken -Encryption A256CBC_HS"; ExpectedAlgorithms = $aes256HmacEncryption -join ' ' }

                # With Quotes
                @{ TextInput = "New-JsonWebToken -Encryption '"; ExpectedAlgorithms = JoinStringsWithSingleQuote $allEncryptions }
                @{ TextInput = "Test-JsonWebToken -Encryption '"; ExpectedAlgorithms = JoinStringsWithSingleQuote $allEncryptions }
                @{ TextInput = "New-JsonWebToken -Encryption 'A128"; ExpectedAlgorithms = JoinStringsWithSingleQuote $aes128Encryptions }
                @{ TextInput = "Test-JsonWebToken -Encryption 'A128"; ExpectedAlgorithms = JoinStringsWithSingleQuote $aes128Encryptions }
                @{ TextInput = "New-JsonWebToken -Encryption 'A256CBC_HS"; ExpectedAlgorithms = JoinStringsWithSingleQuote $aes256HmacEncryption }
                @{ TextInput = "Test-JsonWebToken -Encryption 'A256CBC_HS"; ExpectedAlgorithms = JoinStringsWithSingleQuote $aes256HmacEncryption }

            ) {
                param($TextInput, $ExpectedAlgorithms)
                $res = TabExpansion2 -inputScript $TextInput -cursorColumn $TextInput.Length
                $completionText = $res.CompletionMatches.CompletionText
                $completionText -join ' ' | Should -BeExactly $ExpectedAlgorithms
            }
        }
    }
}
