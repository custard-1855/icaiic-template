// ICAIIC 用の IEEE 会議論文テンプレート.
// もとは Typst Universe の charged-ieee 0.1.4 (MIT-0, Typst GmbH) の lib.typ.
// 公式 IEEEtran.cls ([conference,a4paper]) と同じ本文を組んで行位置を突き合わせ,
// A4 の寸法をそちらに合わせてある.
// 変えた所には「公式:」で始まるコメントを付けた.

// 公式: 本文 10pt の行送りは 12 TeX pt = 11.955pt. Typst の leading は行の下端 (ベースライン) から
// 次の行の上端 (キャップハイト) までなので, TeX Gyre Termes のキャップハイト 0.662em を引く.
#let baselineskip = 11.955pt
#let cap = 0.662
#let body-leading = baselineskip - cap * 10pt
#let small-leading = 8.966pt - cap * 8pt

// 草稿のマーカー. 赤字で出る. 提出前に 0 個にする (build.sh が数える).
//   #ask[...]   ユーザに確かめること      #later[...] あとで書く・直す      #warn[...]  このままでは出せない
#let marker(sign, body) = text(fill: red)[\[#sign\] #body]
#let ask(body) = marker("?", body)
#let later(body) = marker(">", body)
#let warn(body) = marker("!", body)

// This function gets your whole document as its `body` and formats
// it as an article in the style of the IEEE.
#let ieee(
  // The paper's title.
  title: [Paper Title],

  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (),

  // The paper's abstract. Can be omitted if you don't have one.
  abstract: none,

  // A list of index terms to display after the abstract.
  index-terms: (),

  // The article's paper size. Also affects the margins.
  paper-size: "us-letter",

  // The result of a call to the `bibliography` function or `none`.
  bibliography: none,

  // How figures are referred to from within the text.
  // Use "Figure" instead of "Fig." for computer-related publications.
  figure-supplement: [Fig.],

  // The paper's content.
  body
) = {
  // Set document metadata.
  set document(title: title, author: authors.map(author => author.name))

  // Set the body font.
  // As of 2024-08, the IEEE LaTeX template uses wider interword spacing
  // - See e.g. the definition \def\@IEEEinterspaceratioM{0.35} in IEEEtran.cls
  set text(font: "TeX Gyre Termes", size: 10pt, spacing: .35em)
  // 公式: TeX は語の途中で切ることをほとんど嫌わない (\hyphenpenalty 50). Typst の既定のままだと
  // 同じ段落が 1 行長くなることがあるので, ハイフネーションの罰則を下げる.
  set text(costs: (hyphenation: 20%))

  // Enums numbering
  set enum(numbering: "1)a)i)")

  // Tables & figures
  show figure: set block(spacing: 15.5pt)
  // 公式: 段の上下に置く図表と本文の間は \textfloatsep = 1.55 行 (18.5pt).
  // Typst の clearance はベースラインとキャップハイトの間を測るので, 置く側ごとに換算してある.
  // 図は段の上端より 5.3pt 下から始まる (公式は上端から). 図のあとの本文の位置は公式と同じ.
  show figure: set place(clearance: 25.6pt)
  show figure.where(kind: table): set place(clearance: 22.0pt)
  show figure.where(placement: bottom): set place(clearance: 20.5pt)
  // 公式: 図とキャプション, キャプションと表の間.
  show figure: set figure(gap: 11pt)
  show figure.where(kind: table): set figure(gap: 8.2pt)
  show figure.where(kind: table): set figure.caption(position: top, separator: [\ ])
  show figure.where(kind: table): set text(size: 8pt)
  show figure.where(kind: table): set figure(numbering: "I")
  show figure.where(kind: image): set figure(supplement: figure-supplement, numbering: "1")
  show figure.caption: set text(size: 8pt)
  // 公式: 8pt の行送りは 9 TeX pt = 8.966pt (キャプションと文献欄).
  show figure.caption: set par(leading: small-leading)
  show figure.caption: set align(start)
  show figure.caption.where(kind: table): set align(center)

  // Adapt supplement in caption independently from supplement used for
  // references.
  set figure.caption(separator: [. ])
  show figure: fig => {
    let prefix = (
      if fig.kind == table [TABLE]
      else if fig.kind == image [Fig.]
      else [#fig.supplement]
    )
    let numbers = numbering(fig.numbering, ..fig.counter.at(fig.location()))
    // Wrap figure captions in block to prevent the creation of paragraphs. In
    // particular, this means `par.first-line-indent` does not apply.
    // See https://github.com/typst/templates/pull/73#discussion_r2112947947.
    show figure.caption: it => block[#prefix~#numbers#it.separator#it.body]
    show figure.caption.where(kind: table): smallcaps
    fig
  }

  // Code blocks
  show raw: set text(
    font: "TeX Gyre Cursor",
    ligatures: false,
    size: 1em / 0.8,
    spacing: 100%,
  )

  // Configure the page and multi-column properties.
  set columns(gutter: 12pt)
  set page(
    columns: 2,
    paper: paper-size,
    // The margins depend on the paper size.
    margin: if paper-size == "a4" {
      // 公式: 版面は 514.1pt 幅 (段 251.05pt + 段間 12pt), 1 段 56 行.
      // 最初のベースラインが上から 58.9pt, 最後が下から 125.5pt に来る.
      // 下余白は 56 行目が丸め誤差で次の段へ送られないよう 1pt だけ小さくしてある (57 行目は入らない).
      (x: 40.6pt, top: 58.9pt - cap * 10pt, bottom: 124.5pt)
    } else {
      (
        x: (50pt / 216mm) * 100%,
        top: (55pt / 279mm) * 100%,
        bottom: (64pt / 279mm) * 100%,
      )
    }
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  // 公式: 別行立ての式の前後は 1.5ex. 総和記号のある式で測って上 10.7pt, 下 9.4pt.
  show math.equation: set block(above: 10.7pt, below: 9.4pt)

  // Configure appearance of equation references
  show ref: it => {
    if it.element != none and it.element.func() == math.equation {
      // Override equation references.
      link(it.element.location(), numbering(
        it.element.numbering,
        ..counter(math.equation).at(it.element.location())
      ))
    } else {
      // Other references as usual.
      it
    }
  }

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: "I.A.a)")
  show heading: it => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).get()
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(10pt, weight: 400)
    if it.level == 1 {
      // First-level headings are centered smallcaps.
      // We don't want to number the acknowledgment section.
      let is-ack = it.body in ([Acknowledgment], [Acknowledgement], [Acknowledgments], [Acknowledgements])
      set align(center)
      // 公式: 節見出しは本文と同じ 10pt. 前後の空きはベースライン間で 18.7pt / 15.1pt
      // (1.5ex / 0.7ex に行送りを足した自然長. 公式は段の高さをそろえるためここを伸ばす).
      show: block.with(above: 18.7pt - cap * 10pt, below: 15.1pt - cap * 10pt, sticky: true)
      show: smallcaps
      if it.numbering != none and not is-ack {
        numbering("I.", deepest)
        h(7pt, weak: true)
      }
      it.body
    } else if it.level == 2 {
      // Second-level headings are run-ins.
      set text(style: "italic")
      // 公式: 節見出しと同じ空き.
      show: block.with(above: 18.7pt - cap * 10pt, below: 15.1pt - cap * 10pt, sticky: true)
      if it.numbering != none {
        numbering("A.", deepest)
        h(7pt, weak: true)
      }
      it.body
    } else [
      // Third level headings are run-ins too, but different.
      #if it.level == 3 {
        // 公式: 会議論文の第3階層は "1)".
        numbering("1)", deepest)
        [ ]
      }
      _#(it.body):_
    ]
  }

  // Style bibliography.
  show std.bibliography: set text(8pt)
  show std.bibliography: set par(leading: small-leading, spacing: small-leading)
  show std.bibliography: set block(spacing: small-leading)
  set std.bibliography(title: text(10pt)[References], style: "ieee")

  // Display the paper's title and authors at the top of the page,
  // spanning all columns (hence floating at the scope of the
  // columns' parent, which is the page).
  place(
    top,
    float: true,
    scope: "parent",
    // 公式: 著者欄の最終行から本文 1 行目までベースライン間で 38.3pt.
    clearance: 38.3pt - cap * 10pt,
    {
      {
        set align(center)
        set par(leading: 0.5em)
        set text(size: 24pt)
        // 公式: 題名のベースラインは上から 71.2pt, 著者名までは 31.4pt.
        v(71.2pt - 58.9pt - cap * 14pt)
        block(below: 31.4pt - cap * 11pt, title)
      }

      // Display the authors list.
      // 公式: 著者欄の行送りは 12.3pt (斜体の行が混ざるぶん 0.1pt 足してある).
      set par(leading: 12.4pt - cap * 10pt)
      for i in range(calc.ceil(authors.len() / 3)) {
        let end = calc.min((i + 1) * 3, authors.len())
        let is-last = authors.len() == end
        let slice = authors.slice(i * 3, end)
        grid(
          columns: slice.len() * (1fr,),
          gutter: 12pt,
          ..slice.map(author => align(center, {
            text(size: 11pt, author.name)
            if "department" in author [
              \ #emph(author.department)
            ]
            if "organization" in author [
              \ #emph(author.organization)
            ]
            if "location" in author [
              \ #author.location
            ]
            if "email" in author {
              if type(author.email) == str [
                \ #link("mailto:" + author.email)
              ] else [
                \ #author.email
              ]
            }
          }))
        )

        if not is-last {
          v(16pt, weak: true)
        }
      }
    }
  )

  set par(justify: true, first-line-indent: (amount: 1em, all: true), spacing: body-leading, leading: body-leading)

  // Display abstract and index terms.
  if abstract != none {
    // 公式: 要旨は 9pt 太字, 行送り 9.963pt (太字のキャップハイトは 0.676em).
    // 1 行目のベースラインを右段の本文 1 行目にそろえる.
    set par(spacing: 9.963pt - 0.676 * 9pt, leading: 9.963pt - 0.676 * 9pt)
    set text(9pt, weight: 700, spacing: 150%)
    v((cap * 10pt) - (0.676 * 9pt))

    [_Abstract_---#h(weak: true, 0pt)#abstract]

    if index-terms != () {
      parbreak()
      [_Index Terms_---#h(weak: true, 0pt)#index-terms.join[, ]]
    }
    // 公式: キーワードの行のあとに, 節見出しの前の空きに加えて 2.8pt 空く.
    v(2.8pt)
  }

  // Display the paper's contents.
  body

  // Display bibliography.
  bibliography
}
