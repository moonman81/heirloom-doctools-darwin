#!/bin/sh
# verify.sh — post-install smoke test for heirloom-doctools
set -eu
PREFIX="${1:-/opt/heirloom}"
BIN="$PREFIX/bin"

if tty >/dev/null 2>&1; then
	C_OK='\033[32m'; C_FAIL='\033[31m'; C_RESET='\033[0m'
else
	C_OK=''; C_FAIL=''; C_RESET=''
fi
ok()   { printf '  %b✓%b %s\n' "$C_OK" "$C_RESET" "$*"; }
fail() { printf '  %b✗ %s%b\n' "$C_FAIL" "$*" "$C_RESET"; exit 1; }

for t in troff nroff tbl eqn pic grap refer ptx checknr soelim; do
	[ -x "$BIN/$t" ] || fail "$BIN/$t missing"
done
ok 'doctools binaries present'

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

# nroff man-page smoke
cat > "$TMP/t.1" <<'EOF'
.TH TEST 1
.SH NAME
test \- verify smoke
EOF
out=$("$BIN/nroff" -man -Tlp "$TMP/t.1" 2>/dev/null | grep -c 'TEST')
[ "$out" -ge 1 ] || fail "nroff -man output missing 'TEST'"
ok 'nroff -man formats a manual page'

# troff to intermediate output
"$BIN/troff" "$TMP/t.1" > "$TMP/out" 2>/dev/null
[ -s "$TMP/out" ] || fail 'troff produced no output'
ok 'troff produces output'

printf '%bverify: doctools OK%b\n' "$C_OK" "$C_RESET"
