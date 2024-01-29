# Changelog for PoshJsonWebToken

## v.1.0.2 - 29/01/2024

+ Add PlatyPS generated markdown for help #5.
  + Generated markdown help for `New-JsonWebToken` and `Test-JsonWebToken` cmdlets.
+ Add support for generating unprotected tokens #9.
  + Support `none` hash algorithm if user chooses to generate an unprotected token.
  + Emit warning when this algorithm is used.
+ Add manifest tags #10.
+ Add publish test results task for NUnit XML #11.
  + Updated `.github/workflows/ci.yml` to post unit test results to pull request.

## v.1.0.1 - 27/01/2024

+ Minor fixes with PSGallery Publish automation #2.
  + Added `action: write` permission to publish workflow so it can read artifacts.
+ Add more documentation to code #3.
  + Added XML to C# code in particular.

## v.1.0.0 - 27/01/2024

+ Initial version of the `PoshJsonWebToken` module.
+ Add initial cmdlets by @ArmaanMcleod in #1.
