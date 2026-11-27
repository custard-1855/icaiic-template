// ICAIIC 2027 の原稿. ビルド: ./build.sh (確認用 main.pdf と, リンク・しおりを消した提出用 submit.pdf)
// 節の分け方は仮. 変えるときは下の include を直す.
#import "ieee.typ": ieee

#import "front.typ": front

#show: ieee.with(..front, paper-size: "a4", bibliography: bibliography("latex/refs.bib"))

#include "sections/1_introduction.typ"
#include "sections/2_related.typ"
#include "sections/3_preliminaries.typ"
#include "sections/4_experiment.typ"
#include "sections/5_results.typ"
#include "sections/6_conclusion.typ"
