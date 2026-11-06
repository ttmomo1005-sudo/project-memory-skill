# Bootstrap project memory: PROJECT_MEMORY.md + .cursor/rules/project-memory.mdc
# Keep this file ASCII-only: Windows PowerShell 5.1 misreads non-BOM UTF-8 scripts.
param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$ProjectName = "",
  [switch]$Force
)
$ErrorActionPreference = 'Stop'

$skillDir = Split-Path -Parent $PSScriptRoot
$tplDir = Join-Path $skillDir 'templates'
if (-not (Test-Path -LiteralPath $tplDir)) {
  throw "templates folder not found: $tplDir"
}

$root = (Resolve-Path -LiteralPath $ProjectRoot).Path
if (-not $ProjectName) { $ProjectName = Split-Path -Leaf $root }
$date = Get-Date -Format 'yyyy-MM-dd HH:mm'
# BOM-less UTF-8: a BOM before '---' breaks .mdc frontmatter parsing
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Write-FromTemplate([string]$src, [string]$dst) {
  if ((Test-Path -LiteralPath $dst) -and -not $Force) {
    Write-Host "[skip] already exists: $dst"
    return
  }
  $dir = Split-Path -Parent $dst
  if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  $text = [System.IO.File]::ReadAllText($src, [System.Text.Encoding]::UTF8)
  $text = $text.Replace('{{PROJECT_NAME}}', $ProjectName).Replace('{{DATE}}', $date)
  [System.IO.File]::WriteAllText($dst, $text, $utf8NoBom)
  Write-Host "[ok] wrote: $dst"
}

Write-FromTemplate (Join-Path $tplDir 'PROJECT_MEMORY.template.md') (Join-Path $root 'PROJECT_MEMORY.md')
Write-FromTemplate (Join-Path $tplDir 'project-memory.mdc') (Join-Path $root '.cursor\rules\project-memory.mdc')

Write-Host "[done] project memory ready in $root"
