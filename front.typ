// 表題・著者・要旨・キーワード. main.typ が読む.

#let front = (
  title: [Paper Title],
  authors: (
    (
      name: "First Author",
      department: [Department],
      organization: [Organization],
      location: [City, Country],
      email: [email\@example.com],
    ),
  ),
  abstract: [Abstract goes here.],
  index-terms: ("Network digital twin", "Graph neural network"),
)
