# Windows counterpart of build.sh.
# Uses the toolchain in the repo-local .venv (west, cmake, ninja) and the Zephyr SDK
# registered in the CMake package registry. Run from PowerShell:  .\build.ps1
# (or .\build.cmd, which works regardless of the execution policy).
# One-time setup is described in README.md ("로컬 빌드 스크립트").

$venv = Join-Path $PSScriptRoot ".venv\Scripts"
if (-not (Test-Path (Join-Path $venv "west.exe"))) {
    throw "No .venv with west found. See the setup notes at the top of build.ps1."
}
$env:PATH = "$venv;$env:PATH"

# CMake wants forward slashes; the module list is ';'-separated.
$repo    = $PSScriptRoot.Replace('\', '/')
$modules = "$repo/modu-c-firmware/modu-module;$repo/modu-c-firmware/zmk-pmw3610-driver"

Push-Location $PSScriptRoot
try {
    west build -p always `
        -s zmk/app `
        -d build/modu_left `
        -b ms88sf3/nrf52840 `
        -S studio-rpc-usb-uart `
        -- `
        "-DZMK_CONFIG=$repo/config" `
        -DSHIELD=modu_left `
        "-DZMK_EXTRA_MODULES=$modules" `
        -DCONFIG_ZMK_STUDIO=y
    if ($LASTEXITCODE -ne 0) { throw "Left half build failed (exit $LASTEXITCODE)" }

    west build -p always `
        -s zmk/app `
        -d build/modu_right `
        -b ms88sf3/nrf52840 `
        -- `
        "-DZMK_CONFIG=$repo/config" `
        -DSHIELD=modu_right `
        "-DZMK_EXTRA_MODULES=$modules"
    if ($LASTEXITCODE -ne 0) { throw "Right half build failed (exit $LASTEXITCODE)" }

    # ------------------------------------------------------------
    # Copy final UF2 files
    # ------------------------------------------------------------
    $results = Join-Path $PSScriptRoot "results"
    New-Item -ItemType Directory -Force -Path $results | Out-Null
    Copy-Item -ErrorAction Stop "build\modu_left\zephyr\zmk.uf2"  (Join-Path $results "modu_left.uf2")  -Force
    Copy-Item -ErrorAction Stop "build\modu_right\zephyr\zmk.uf2" (Join-Path $results "modu_right.uf2") -Force

    Write-Host ""
    Write-Host "======================================"
    Write-Host "Build complete"
    Write-Host "======================================"
    Write-Host "Left : $results\modu_left.uf2"
    Write-Host "Right: $results\modu_right.uf2"
}
finally {
    Pop-Location
}
