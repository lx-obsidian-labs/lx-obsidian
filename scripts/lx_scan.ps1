<#
.SYNOPSIS
  lx_scan — dependency-free scanner for the code-certain "AI slop" tells in
  Dart/Flutter source. The fallback for toolchains older than Dart 3.10, or a
  quick one-shot scan. Mirrors packages/lx_slop_lint.

.EXAMPLE
  pwsh scripts/lx_scan.ps1 -Path lib -MinSeverity P1
  pwsh scripts/lx_scan.ps1 -Path . -Ignore 'legacy/**','**/*.g.dart'
#>
[CmdletBinding()]
param(
  [string]   $Path = 'lib',
  [ValidateSet('P0','P1','P2')]
  [string]   $MinSeverity = 'P2',
  [string[]] $Ignore = @(),
  [switch]   $NoHeader
)

$ErrorActionPreference = 'Stop'

$sevRank = @{ P0 = 0; P1 = 1; P2 = 2 }
$min = $sevRank[$MinSeverity]

$rules = @(
  @{ Id='hardcoded_color';    Sev='P0'; Msg='Hardcoded Color(); use a colorScheme role or AppTokens.'
     Pattern='Color\.fromARGB\(|Color\.fromRGBO\(|Color\(\s*0x' }
  @{ Id='framework_color';    Sev='P0'; Msg='Framework color swatch; use a semantic token.'
     Pattern='\bColors\.(blue|blueGrey|brown|cyan|deepOrange|deepPurple|green|grey|indigo|lightBlue|lightGreen|lime|orange|pink|purple|red|teal|yellow|amber|violet)\b' }
  @{ Id='default_theme';      Sev='P0'; Msg='Reflex Material seed; choose a seed from the subject.'
     Pattern='ColorScheme\.fromSeed\(\s*seedColor:\s*Colors\.(deepPurple|indigo|blue|purple|violet)' }
  @{ Id='hardcoded_spacing';  Sev='P0'; Msg='Magic-number spacing; use the spacing scale.'
     Pattern='(SizedBox\(\s*(height|width|dimension):\s*-?\d|EdgeInsets\.\w+\([^)]*-?\d)' }
  @{ Id='hardcoded_radius';   Sev='P1'; Msg='Literal radius; use the radius ladder.'
     Pattern='(BorderRadius|Radius)\.circular\(\s*-?\d' }
  @{ Id='hardcoded_font_size';Sev='P0'; Msg='Literal fontSize; use the type scale.'
     Pattern='fontSize:\s*-?\d' }
  @{ Id='hardcoded_elevation';Sev='P1'; Msg='Literal elevation/shadow; use a ladder or borders.'
     Pattern='(elevation|blurRadius|spreadRadius):\s*-?\d' }
  @{ Id='orientation_lock';   Sev='P0'; Msg='Orientation lock; support both orientations.'
     Pattern='setPreferredOrientations' }
  @{ Id='linear_motion';      Sev='P1'; Msg='Linear curve; use an ease/spring token.'
     Pattern='Curves\.linear' }
  @{ Id='emoji_icon';         Sev='P0'; Msg='Emoji as icon; use a real icon set.'
     Pattern="Text\(\s*['""][^'""]*[\u2190-\u21FF\u2600-\u27BF\u2B00-\u2BFF\uD83C-\uDBFF\uDC00-\uDFFF]" }
)

function Test-Ignored([string]$rel) {
  foreach ($g in $Ignore) {
    if ($rel -like $g) { return $true }
    try { if ([regex]::IsMatch($rel, $g -replace '\*\*', '.*' -replace '\*', '[^/]*')) { return $true } } catch {}
  }
  return $false
}

$root = (Resolve-Path -LiteralPath $Path).Path
$files = Get-ChildItem -LiteralPath $root -Recurse -File -Filter *.dart |
  Where-Object { $_.Name -notmatch '\.g\.dart$|\.freezed\.dart$' }

$hits = @()
foreach ($f in $files) {
  $rel = $f.FullName.Substring($root.Length).TrimStart('\','/') -replace '\\','/'
  if (Test-Ignored $rel) { continue }
  $lines = Get-Content -LiteralPath $f.FullName
  for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line -match '//\s*ignore:') { continue }
    foreach ($r in $rules) {
      if ($sevRank[$r.Sev] -gt $min) { continue }
      if ($line -match $r.Pattern) {
        $hits += [pscustomobject]@{
          File = $rel; Line = $i + 1; Rule = $r.Id; Severity = $r.Sev; Message = $r.Msg
        }
      }
    }
  }
}

if (-not $NoHeader) {
  Write-Host ("lx_scan  path={0}  min={1}  files={2}" -f $Path, $MinSeverity, $files.Count)
}

if (-not $hits) {
  Write-Host "No findings."
  exit 0
}

$hits | Sort-Object Severity, File, Line | ForEach-Object {
  "{0}:{1}  {2}  {3}  {4}" -f $_.File, $_.Line, $_.Rule, $_.Severity, $_.Message
}

$counts = $hits | Group-Object Severity | Sort-Object Name
Write-Host ""
Write-Host ("Total: {0} findings  ({1})" -f $hits.Count, (($counts | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ', '))
