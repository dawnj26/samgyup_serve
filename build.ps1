#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Build script for Flutter project with packages support
.DESCRIPTION
    PowerShell equivalent of the Makefile for managing dependencies, code generation, and releases
.PARAMETER Target
    The build target to execute (deps, update, update-major, generate, generate-only, release-prod, release-stg, release-web, help)
.PARAMETER FlutterExecutable
    Path to flutter executable (default: flutter)
.PARAMETER DartExecutable
    Path to dart executable (default: dart)
.EXAMPLE
    .\build.ps1 deps
.EXAMPLE
    .\build.ps1 generate -FlutterExecutable "C:\flutter\bin\flutter.exe"
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet('deps', 'update', 'update-major', 'generate', 'generate-only', 'release-prod', 'release-stg', 'release-web', 'help')]
    [string]$Target,
    
    [Parameter()]
    [string]$FlutterExecutable = 'flutter',
    
    [Parameter()]
    [string]$DartExecutable = 'dart'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Global variables
$script:Packages = @()
$script:RootHasBuildRunner = $false
$script:BuildRunnerPackages = @()

function Initialize-PackageDiscovery {
    <#
    .SYNOPSIS
        Discovers packages and build_runner dependencies
    #>
    
    # Find all package directories (having a pubspec.yaml) inside packages/
    if (Test-Path 'packages') {
        $packagePubspecs = Get-ChildItem -Path 'packages' -Recurse -Name 'pubspec.yaml' -Depth 1 | Sort-Object
        $script:Packages = $packagePubspecs | ForEach-Object { 
            Split-Path (Join-Path 'packages' $_) -Parent 
        }
    }
    
    # Determine if root has build_runner
    if (Test-Path 'pubspec.yaml') {
        $rootContent = Get-Content 'pubspec.yaml' -Raw
        $script:RootHasBuildRunner = $rootContent -match '^\s*[^#].*build_runner:'
    }
    
    # Determine which packages use build_runner
    $script:BuildRunnerPackages = @()
    foreach ($package in $script:Packages) {
        $pubspecPath = Join-Path $package 'pubspec.yaml'
        if (Test-Path $pubspecPath) {
            $content = Get-Content $pubspecPath -Raw
            if ($content -match '^\s*[^#].*build_runner:') {
                $script:BuildRunnerPackages += $package
            }
        }
    }
}

function Show-Help {
    <#
    .SYNOPSIS
        Shows available build targets and options
    #>
    
    Write-Host "Available Targets:" -ForegroundColor Green
    Write-Host "  deps         - Run 'flutter pub get' in root and all packages"
    Write-Host "  update       - Run 'flutter pub upgrade' in root and all packages"
    Write-Host "  update-major - Run 'flutter pub upgrade --major-versions' in root and all packages"
    Write-Host "  generate     - Run build_runner build in root (if needed) and in packages needing it"
    Write-Host "  generate-only - Run build_runner build without fetching dependencies first"
    Write-Host "  release-prod - Generate code and build production APK with ABI splits"
    Write-Host "  release-stg  - Generate code and build staging APK with ABI splits"
    Write-Host "  release-web  - Generate code and build web with WASM"
    Write-Host ""
    Write-Host "Parameters:" -ForegroundColor Green
    Write-Host "  -FlutterExecutable <path>  Path to flutter executable (default: flutter)"
    Write-Host "  -DartExecutable <path>     Path to dart executable (default: dart)"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Green
    Write-Host "  .\build.ps1 deps"
    Write-Host "  .\build.ps1 generate -FlutterExecutable 'C:\flutter\bin\flutter.exe'"
}

function Invoke-DependenciesRoot {
    <#
    .SYNOPSIS
        Gets dependencies for the root project
    #>
    
    Write-Host "==> Getting dependencies (root)" -ForegroundColor Cyan
    try {
        & $FlutterExecutable pub get
        if ($LASTEXITCODE -ne 0) {
            throw "Flutter pub get failed for root with exit code $LASTEXITCODE"
        }
    }
    catch {
        Write-Error "Failed to get dependencies for root: $_"
        throw
    }
}

function Invoke-DependenciesPackages {
    <#
    .SYNOPSIS
        Gets dependencies for all packages
    #>
    
    if ($script:Packages.Count -eq 0) {
        Write-Host "No packages/ subpackages detected." -ForegroundColor Yellow
        return
    }
    
    Write-Host "==> Getting dependencies (packages)" -ForegroundColor Cyan
    foreach ($package in $script:Packages) {
        Write-Host "--> $package" -ForegroundColor Gray
        try {
            Push-Location $package
            & $FlutterExecutable pub get
            if ($LASTEXITCODE -ne 0) {
                throw "Flutter pub get failed for $package with exit code $LASTEXITCODE"
            }
        }
        catch {
            Write-Error "Failed to get dependencies for $package`: $_"
            throw
        }
        finally {
            Pop-Location
        }
    }
}

function Invoke-Dependencies {
    <#
    .SYNOPSIS
        Gets dependencies for packages and root
    #>
    
    Invoke-DependenciesPackages
    Invoke-DependenciesRoot
}

function Invoke-UpdateRoot {
    <#
    .SYNOPSIS
        Updates dependencies for the root project
    #>
    
    Write-Host "==> Updating dependencies (root)" -ForegroundColor Cyan
    try {
        & $FlutterExecutable pub upgrade
        if ($LASTEXITCODE -ne 0) {
            throw "Flutter pub upgrade failed for root with exit code $LASTEXITCODE"
        }
    }
    catch {
        Write-Error "Failed to update dependencies for root: $_"
        throw
    }
}

function Invoke-UpdatePackages {
    <#
    .SYNOPSIS
        Updates dependencies for all packages
    #>
    
    if ($script:Packages.Count -eq 0) {
        Write-Host "No packages/ subpackages detected." -ForegroundColor Yellow
        return
    }
    
    Write-Host "==> Updating dependencies (packages)" -ForegroundColor Cyan
    foreach ($package in $script:Packages) {
        Write-Host "--> $package" -ForegroundColor Gray
        try {
            Push-Location $package
            & $FlutterExecutable pub upgrade
            if ($LASTEXITCODE -ne 0) {
                throw "Flutter pub upgrade failed for $package with exit code $LASTEXITCODE"
            }
        }
        catch {
            Write-Error "Failed to update dependencies for $package`: $_"
            throw
        }
        finally {
            Pop-Location
        }
    }
}

function Invoke-Update {
    <#
    .SYNOPSIS
        Updates dependencies for packages and root
    #>
    
    Invoke-UpdatePackages
    Invoke-UpdateRoot
}

function Invoke-UpdateMajorRoot {
    <#
    .SYNOPSIS
        Updates dependencies with major versions for the root project
    #>
    
    Write-Host "==> Updating dependencies with major versions (root)" -ForegroundColor Cyan
    try {
        & $FlutterExecutable pub upgrade --major-versions
        if ($LASTEXITCODE -ne 0) {
            throw "Flutter pub upgrade --major-versions failed for root with exit code $LASTEXITCODE"
        }
    }
    catch {
        Write-Error "Failed to update major dependencies for root: $_"
        throw
    }
}

function Invoke-UpdateMajorPackages {
    <#
    .SYNOPSIS
        Updates dependencies with major versions for all packages
    #>
    
    if ($script:Packages.Count -eq 0) {
        Write-Host "No packages/ subpackages detected." -ForegroundColor Yellow
        return
    }
    
    Write-Host "==> Updating dependencies with major versions (packages)" -ForegroundColor Cyan
    foreach ($package in $script:Packages) {
        Write-Host "--> $package" -ForegroundColor Gray
        try {
            Push-Location $package
            & $FlutterExecutable pub upgrade --major-versions
            if ($LASTEXITCODE -ne 0) {
                throw "Flutter pub upgrade --major-versions failed for $package with exit code $LASTEXITCODE"
            }
        }
        catch {
            Write-Error "Failed to update major dependencies for $package`: $_"
            throw
        }
        finally {
            Pop-Location
        }
    }
}

function Invoke-UpdateMajor {
    <#
    .SYNOPSIS
        Updates dependencies with major versions for packages and root
    #>
    
    Invoke-UpdateMajorPackages
    Invoke-UpdateMajorRoot
}

function Invoke-GenerateRoot {
    <#
    .SYNOPSIS
        Runs build_runner for the root project if needed
    #>
    
    if ($script:RootHasBuildRunner) {
        Write-Host "==> build_runner (root)" -ForegroundColor Cyan
        try {
            & $DartExecutable run build_runner build --delete-conflicting-outputs
            if ($LASTEXITCODE -ne 0) {
                throw "Build runner failed for root with exit code $LASTEXITCODE"
            }
        }
        catch {
            Write-Error "Failed to run build_runner for root: $_"
            throw
        }
    }
    else {
        Write-Host "Root does not depend on build_runner (skipping)." -ForegroundColor Yellow
    }
}

function Invoke-GeneratePackages {
    <#
    .SYNOPSIS
        Runs build_runner for packages that need it
    #>
    
    if ($script:BuildRunnerPackages.Count -eq 0) {
        Write-Host "No packages with build_runner dependency found." -ForegroundColor Yellow
        return
    }
    
    Write-Host "==> build_runner (packages)" -ForegroundColor Cyan
    foreach ($package in $script:BuildRunnerPackages) {
        Write-Host "--> $package" -ForegroundColor Gray
        try {
            Push-Location $package
            & $DartExecutable run build_runner build --delete-conflicting-outputs
            if ($LASTEXITCODE -ne 0) {
                throw "Build runner failed for $package with exit code $LASTEXITCODE"
            }
        }
        catch {
            Write-Error "Failed to run build_runner for $package`: $_"
            throw
        }
        finally {
            Pop-Location
        }
    }
}

function Invoke-Generate {
    <#
    .SYNOPSIS
        Runs dependencies and then build_runner for packages and root
    #>
    
    Invoke-Dependencies
    Invoke-GeneratePackages
    Invoke-GenerateRoot
}

function Invoke-GenerateOnly {
    <#
    .SYNOPSIS
        Runs build_runner for packages and root without fetching dependencies
    #>
    
    Invoke-GeneratePackages
    Invoke-GenerateRoot
}

function Invoke-ReleaseProd {
    <#
    .SYNOPSIS
        Generates code and builds production APK with ABI splits
    #>
    
    Invoke-Generate
    Write-Host "==> Building production APK" -ForegroundColor Cyan
    try {
        & $FlutterExecutable build apk --flavor production --split-per-abi -t lib/main_production.dart
        if ($LASTEXITCODE -ne 0) {
            throw "Production build failed with exit code $LASTEXITCODE"
        }
    }
    catch {
        Write-Error "Failed to build production APK: $_"
        throw
    }
}

function Invoke-ReleaseStg {
    <#
    .SYNOPSIS
        Generates code and builds staging APK with ABI splits
    #>
    
    Invoke-Generate
    Write-Host "==> Building staging APK" -ForegroundColor Cyan
    try {
        & $FlutterExecutable build apk --flavor staging --split-per-abi -t lib/main_staging.dart
        if ($LASTEXITCODE -ne 0) {
            throw "Staging build failed with exit code $LASTEXITCODE"
        }
    }
    catch {
        Write-Error "Failed to build staging APK: $_"
        throw
    }
}

function Invoke-ReleaseWeb {
    <#
    .SYNOPSIS
        Generates code and builds web with WASM
    #>
    
    Invoke-Generate
    Write-Host "==> Building web" -ForegroundColor Cyan
    try {
        & $FlutterExecutable build web --wasm -t lib/main_production.dart
        if ($LASTEXITCODE -ne 0) {
            throw "Web build failed with exit code $LASTEXITCODE"
        }
    }
    catch {
        Write-Error "Failed to build web: $_"
        throw
    }
}

# Main execution
try {
    # Initialize package discovery
    Initialize-PackageDiscovery
    
    # Execute the requested target
    switch ($Target) {
        'deps' { Invoke-Dependencies }
        'update' { Invoke-Update }
        'update-major' { Invoke-UpdateMajor }
        'generate' { Invoke-Generate }
        'generate-only' { Invoke-GenerateOnly }
        'release-prod' { Invoke-ReleaseProd }
        'release-stg' { Invoke-ReleaseStg }
        'release-web' { Invoke-ReleaseWeb }
        'help' { Show-Help }
        default { 
            Write-Error "Unknown target: $Target"
            Show-Help
            exit 1
        }
    }
    
    Write-Host "Target '$Target' completed successfully!" -ForegroundColor Green
}
catch {
    Write-Error "Target '$Target' failed: $_"
    exit 1
}