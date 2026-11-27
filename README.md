# ICAIIC 2027 原稿テンプレート (IEEE 会議論文形式, A4, 2段組)

同じ体裁の原稿を Typst でも LaTeX でも書けるようにしたもの. どちらか一方だけ使えばよい.

| | 場所 | 本体 |
|---|---|---|
| Typst 版 | ルート (`main.typ`) | `ieee.typ`. Typst Universe の charged-ieee 0.1.4 を公式の寸法に合わせた写し |
| LaTeX 版 | `latex/` (`main.tex`) | IEEE 公式の `IEEEtran.cls` / `IEEEtran.bst` そのまま |

文献 (`latex/refs.bib`) は両方で共用する.

**どちらを使うか**: LaTeX 版は公式のクラスそのものなので, 体裁について心配が無い.
Typst 版は同じ本文を組むと公式と同じ行で段とページが替わるところまで合わせてあるが, 下の「Typst 版と公式の差」が残り,
カメラレディで求められる IEEE PDF eXpress の検査にはまだ通していない.

## Typst 版

必要なもの: [Typst](https://github.com/typst/typst) (`brew install typst`. 無ければ Quarto 同梱のものを使う) と,
[uv](https://docs.astral.sh/uv/) (提出用 PDF からリンクとしおりを消す `strip_links.py` にだけ使う).

```sh
./build.sh    # main.pdf (確認用) と submit.pdf (提出用. リンクとしおり無し)
```

- `front.typ` — 表題・著者・要旨・キーワード
- `sections/*.typ` — 本文. 節を増減するときは `main.typ` の `#include` も直す
- `latex/refs.bib` — 文献 (LaTeX 版と共用). 本文では `@sample2024` のように引く
- `ieee.typ` — テンプレート本体. ふつうは触らない
- `fonts/` — TeX Gyre Termes / Cursor. `build.sh` はここのフォントだけを使う

`#ask[...]` `#later[...]` `#warn[...]` は赤字で出る草稿用の印で, 残っていると `build.sh` が個数を警告する.
ページ数の上限 (6) は `build.sh` の `MAX_PAGES`.

## LaTeX 版

- `latex/main.tex` — 原稿. 表題から本文まで 1 ファイル
- `latex/refs.bib` — 文献 (Typst 版と共用). 本文では `\cite{sample2024}` のように引く
- `latex/bstctl.bib` — 文献欄の設定 (著者 7 名以上は筆頭著者 + et al.)

`latex/` はこのフォルダだけで閉じているので, 組む環境は次のどちらでもよい.

### Overleaf (何も入れない)

`latex/` の中身をそのまま Overleaf のプロジェクトに上げる (フォルダを zip にして New Project → Upload Project).
コンパイラは既定の pdfLaTeX のままでよい.

### 手元で組む (TinyTeX)

[TinyTeX](https://yihui.org/tinytex/) は数百 MB の小さな TeX Live. Quarto があれば `quarto install tinytex` でも入る.
入れたあと, このテンプレートが使うパッケージを足す (既に入っているものは飛ばされる).

```sh
tlmgr install latexmk bibtex cite algorithms amsmath amsfonts graphics graphics-cfg graphics-def \
  epstopdf-pkg xcolor psnfss times courier helvetic l3backend url
./latex/build.sh    # latex/main.pdf
```

MacTeX や TeX Live を全部入りで入れてあるなら, 何も足さずに `./latex/build.sh` が通る.
自分でパッケージを `\usepackage` して `File '...sty' not found` と出たら, `tlmgr install <名前>` で足す.

## Typst 版と公式の差

- 段の上に置いた図は公式より 5.3pt 下から始まる. 図のあとの本文の位置は同じ.
- 表は Typst のセルの余白のぶん高くなる (2 行の表で約 6pt). `inset` で詰められる.
- 文献欄は DOI を出し, 題名の大文字を元のまま残す. 公式の bst は DOI を出さず, 題名を小文字にする.
- 「References」の見出しと 1 件目の間が 1pt 狭い.
- 公式は段の下端をそろえるために空きを伸ばす. Typst 版は伸ばさない.

## 提出の決まり (ICAIIC 2027)

- EDAS に PDF で提出. 3〜6 ページ, 2段組, 10pt 以上.
- カメラレディは IEEE PDF eXpress の検査に通した PDF を上げる (フォントの埋め込み, しおり・リンク無し).
  Typst 版の `submit.pdf` は手元の検査ではこれを満たすが, PDF eXpress そのものにはまだ通していない.

## ライセンス

MIT-0 (表示義務なし). このテンプレートで書いた原稿には何の義務も残らない.
同梱している `latex/IEEEtran.cls`, `latex/IEEEtran.bst` (LPPL 1.3) と `fonts/` (GUST Font License) は別で, 無改変のまま置いてある.
詳しくは [LICENSE](LICENSE).
