#!/bin/sh
# 確認用 main.pdf と, 提出用 submit.pdf (リンク・しおり無し) を作る. どこから呼んでもよい.
# コンパイルエラーのときだけ失敗する. ページ数の超過と草稿マーカーの残りは警告として出す.
set -eu
cd "$(dirname "$0")"

MAX_PAGES=6

# 単体の typst が無ければ Quarto 同梱のものを使う.
if command -v typst >/dev/null 2>&1; then
  TYPST=typst
else
  TYPST="${QUARTO:-$HOME/Applications/quarto/bin/quarto} typst"
fi
# フォントは fonts/ のものだけを使う (手元に無いフォントへ黙って置き換わるのを防ぐ).
OPTS="--font-path fonts --ignore-system-fonts"

$TYPST compile $OPTS main.typ main.pdf
# 提出用はタグ無しで組む (リンクを消すとタグ構造に宙に浮いた参照が残るため).
$TYPST compile $OPTS --no-pdf-tags main.typ submit.pdf
uv run --quiet --with pymupdf python strip_links.py submit.pdf submit.pdf "$MAX_PAGES"

markers=$(cat main.typ front.typ sections/*.typ | grep -o -E '#(ask|later|warn)\[' | wc -l | tr -d ' ')
[ "$markers" -eq 0 ] || echo "警告: 草稿マーカー (#ask / #later / #warn) が $markers 個残っている"
