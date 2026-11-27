"""PDF eXpress (Option 2) 向けに, PDF からリンク注釈としおりを取り除く.

使い方: uv run --with pymupdf python strip_links.py in.pdf out.pdf [ページ数の上限] (in と out は同じファイルでもよい)
Typst は引用 → 文献欄の内部リンクを show 規則で消せないので, 出力後に消す.
"""
import sys

import pymupdf


def main(src: str, dst: str, max_pages: int = 0) -> None:
    doc = pymupdf.open(src)
    removed = 0
    for page in doc:
        for link in page.get_links():
            page.delete_link(link)
            removed += 1
    doc.set_toc([])
    data = doc.tobytes(garbage=3, deflate=True)
    doc.close()
    with open(dst, "wb") as f:
        f.write(data)
    check = pymupdf.open(dst)
    left = sum(len(p.get_links()) for p in check)
    if left or check.get_toc():
        sys.exit(f"リンク {left} 個またはしおりが残っている: {dst}")
    print(f"{dst}: リンク {removed} 個を削除, {check.page_count} ページ")
    if max_pages and check.page_count > max_pages:
        print(f"警告: {check.page_count} ページある (上限 {max_pages} ページ)")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 0)
