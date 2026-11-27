#!/bin/sh
# LaTeX 版を組む. 出力は latex/main.pdf. どこから呼んでもよい.
# latexmk が要る (TeX Live / MacTeX / TinyTeX). Quarto が入れた TinyTeX があればそれも探す.
set -eu
cd "$(dirname "$0")"
[ -d "$HOME/Library/TinyTeX/bin/universal-darwin" ] && PATH="$HOME/Library/TinyTeX/bin/universal-darwin:$PATH"
latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex
