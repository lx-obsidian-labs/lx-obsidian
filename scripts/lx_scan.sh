#!/usr/bin/env bash
# lx_scan — dependency-free scanner for the code-certain "AI slop" tells in
# Dart/Flutter source. The fallback for toolchains older than Dart 3.10, or a
# quick one-shot scan. Mirrors packages/lx_slop_lint.
#
# Usage:
#   bash scripts/lx_scan.sh [path] [min-severity]
#   bash scripts/lx_scan.sh lib P1
set -euo pipefail

PATH_ARG="${1:-lib}"
MIN="${2:-P2}"

case "$MIN" in
  P0) ;;
  P1) ;;
  P2) ;;
  *) echo "min-severity must be P0, P1, or P2" >&2; exit 2 ;;
esac

if [ ! -e "$PATH_ARG" ]; then
  echo "path not found: $PATH_ARG" >&2
  exit 2
fi

# rule_id|severity|regex|message
rules=(
  'hardcoded_color|P0|Color\.fromARGB\(|Color\.fromRGBO\(|Color\(\s*0x|Hardcoded Color(); use a colorScheme role or AppTokens.'
  'framework_color|P0|\bColors\.(blue|blueGrey|brown|cyan|deepOrange|deepPurple|green|grey|indigo|lightBlue|lightGreen|lime|orange|pink|purple|red|teal|yellow|amber|violet)\b|Framework color swatch; use a semantic token.'
  'default_theme|P0|ColorScheme\.fromSeed\(.*seedColor:\s*Colors\.(deepPurple|indigo|blue|purple|violet)|Reflex Material seed; choose a seed from the subject.'
  'hardcoded_spacing|P0|(SizedBox\(\s*(height|width|dimension):\s*-?[0-9]|EdgeInsets\.[a-zA-Z]+\([^)]*-?[0-9])|Magic-number spacing; use the spacing scale.'
  'hardcoded_radius|P1|(BorderRadius|Radius)\.circular\(\s*-?[0-9]|Literal radius; use the radius ladder.'
  'hardcoded_font_size|P0|fontSize:\s*-?[0-9]|Literal font size; use the type scale.'
  'hardcoded_elevation|P1|(elevation|blurRadius|spreadRadius):\s*-?[0-9]|Literal elevation/shadow; use a ladder or borders.'
  'orientation_lock|P0|setPreferredOrientations|Orientation lock; support both orientations.'
  'linear_motion|P1|Curves\.linear|Linear curve; use an ease/spring token.'
)

rank() { case "$1" in P0) echo 0 ;; P1) echo 1 ;; P2) echo 2 ;; esac; }
MIN_RANK="$(rank "$MIN")"

total=0
printf 'lx_scan  path=%s  min=%s\n' "$PATH_ARG" "$MIN"

files="$(find "$PATH_ARG" -type f -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart' 2>/dev/null || true)"
[ -z "$files" ] && { echo "No Dart files found."; exit 0; }

for rule in "${rules[@]}"; do
  IFS='|' read -r id sev regex msg <<< "$rule"
  [ "$(rank "$sev")" -gt "$MIN_RANK" ] && continue
  matches="$(grep -rnE "$regex" $files 2>/dev/null | grep -vE '//\s*ignore:' || true)"
  [ -z "$matches" ] && continue
  while IFS= read -r m; do
    [ -z "$m" ] && continue
    file="${m%%:*}"
    rest="${m#*:}"
    line="${rest%%:*}"
    printf '%s:%s  %s  %s  %s\n' "$file" "$line" "$id" "$sev" "$msg"
    total=$((total + 1))
  done <<< "$matches"
done

echo ""
echo "Total: $total findings"
