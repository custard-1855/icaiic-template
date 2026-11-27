# ICAIIC 2027 原稿テンプレート (IEEE 会議論文形式, A4, 2段組)

同じ体裁の原稿を Typst でも LaTeX でも書けるようにしたもの. どちらか一方だけ使えばよい.

| | 場所 | 本体 |
|---|---|---|
| Typst 版 | ルート (`main.typ`) | `ieee.typ`. Typst Universe の charged-ieee 0.1.4 を公式の寸法に合わせた写し |
| LaTeX 版 | `latex/` (`main.tex`) | IEEE 公式の `IEEEtran.cls` / `IEEEtran.bst` そのまま |

文献 (`refs.bib`) は両方で共用する.

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
- `refs.bib` — 文献. 本文では `@sample2024` のように引く
- `ieee.typ` — テンプレート本体. ふつうは触らない
- `fonts/` — TeX Gyre Termes / Cursor. `build.sh` はここのフォントだけを使う

`#ask[...]` `#later[...]` `#warn[...]` は赤字で出る草稿用の印で, 残っていると `build.sh` が個数を警告する.
ページ数の上限 (6) は `build.sh` の `MAX_PAGES`.

## LaTeX 版

必要なもの: `latexmk` の入った TeX 環境 (TeX Live, MacTeX, TinyTeX のどれか).

```sh
./latex/build.sh    # latex/main.pdf
```

- `latex/main.tex` — 原稿. 表題から本文まで 1 ファイル
- `latex/bstctl.bib` — 文献欄の設定 (著者 7 名以上は筆頭著者 + et al.)
- 文献はルートの `refs.bib` を読む. 本文では `\cite{sample2024}` のように引く

Overleaf で使うときは, `latex/` の中身と `refs.bib` を上げ, `main.tex` の `\bibliography{bstctl,../refs}` を `{bstctl,refs}` に直す.

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

## 同梱物のライセンス

- `ieee.typ` — charged-ieee (Typst GmbH, MIT-0) を改変したもの
- `fonts/` — TeX Gyre (GUST Font License)
- `latex/IEEEtran.cls`, `latex/IEEEtran.bst` — IEEE 配布のもの (LPPL 1.3)
