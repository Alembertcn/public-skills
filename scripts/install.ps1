param(
    [string[]]$Skill
)

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Dest = if ($env:CURSOR_SKILLS_DIR) { $env:CURSOR_SKILLS_DIR } else { Join-Path $env:USERPROFILE ".cursor\skills" }

function Install-One($Id) {
    $Src = Join-Path $Root "skills\$Id"
    if (-not (Test-Path (Join-Path $Src "SKILL.md"))) {
        Write-Error "未找到 $Src\SKILL.md"
    }
    $Target = Join-Path $Dest $Id
    if (Test-Path $Target) { Remove-Item -Recurse -Force $Target }
    New-Item -ItemType Directory -Force -Path $Dest | Out-Null
    Copy-Item -Recurse $Src $Target
    Write-Host "已安装: $Target"
}

if ($Skill.Count -gt 0) {
    foreach ($s in $Skill) { Install-One $s }
} else {
    Get-ChildItem (Join-Path $Root "skills") -Directory | ForEach-Object {
        if ($_.Name -eq "_template") { return }
        Install-One $_.Name
    }
}

Write-Host "Done. 详见 docs/cursor-setup.md"
