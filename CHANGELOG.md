# Changelog for PoshJsonWebToken

## Unreleased

### General Cmdlet Updates and Fixes

+ Moved `-Algorithm` parameter to base class and changed type from `JwsAlgorithm` to `string` (#16).

## v.1.0.2 - 29/01/2024

### General Cmdlet Updates and Fixes

+ Add support for generating unprotected tokens (#9).
  + Support `none` hash algorithm if user chooses to generate an unprotected token.
  + Emit warning when this algorithm is used.

### Build and Packaging Improvements

+ Add PlatyPS generated markdown for help (#5).
  + Generated markdown help for `New-JsonWebToken` and `Test-JsonWebToken` cmdlets.
+ Add manifest tags (#10).
+ Add publish test results task for NUnit XML (#11).
  + Updated `.github/workflows/ci.yml` to post unit test results to pull request.

## v.1.0.1 - 27/01/2024

### Build and Packaging Improvements

+ Minor fixes with PSGallery Publish automation (#2).
  + Added `action: write` permission to publish workflow so it can read artifacts.

### Documentation and Help Content

+ Add more documentation to code (#3).
  + Added XML to C# code in particular.

## v.1.0.0 - 27/01/2024

### General Cmdlet Updates and Fixes

+ Initial version of the `PoshJsonWebToken` module (#1).
  + Included `New-JsonWebToken` and `Test-JsonWebToken` cmdlets.
