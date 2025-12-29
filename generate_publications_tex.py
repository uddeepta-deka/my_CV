import re
import bibtexparser
from bibtexparser.bparser import BibTexParser

YOUR_SURNAME = "Deka"
YOUR_INITIAL = "U."

def clean_title(title):
    # Remove outer braces only if they wrap the whole title
    if title.startswith("{") and title.endswith("}"):
        title = title[1:-1]
    # Remove BibTeX capitalization braces: {G} -> G
    title = re.sub(r"[{}]", "", title)
    return title

def format_author(author):
    parts = [p.strip() for p in author.split(",")]
    surname = parts[0]
    given = parts[1] if len(parts) > 1 else ""
    initials = " ".join(g[0] + "." for g in given.split() if g)
    name = f"{initials} {surname}".strip()
    if surname == YOUR_SURNAME:
        name = f"\\textbf{{{name}}}"
    return name

def format_authors(author_field):
    authors = author_field.replace(" and others", "").split(" and ")
    return ", ".join(format_author(a) for a in authors)

def arxiv_link(eprint):
    return f"\\href{{https://arxiv.org/abs/{eprint}}}{{arXiv:{eprint}}}"

def journal_link(entry):
    if "doi" in entry:
        journal = entry.get("journal", "")
        volume = entry.get("volume", "")
        pages = entry.get("pages", "")
        return f"\\href{{https://doi.org/{entry['doi']}}}{{{journal} {volume}, {pages}}}"
    return ""

def normalize_collaboration(collab):
    parts = [p.strip() for p in collab.split(",")]
    if len(parts) > 1:
        return ", ".join(parts[:-1]) + " and " + parts[-1]
    return collab

parser = BibTexParser(common_strings=True)
with open("./sections/publications.bib") as f:
    entries = bibtexparser.load(f, parser).entries

short_author = []
long_author = []

for e in entries:
    if "collaboration" in e:
        long_author.append(e)
    else:
        short_author.append(e)

short_author.sort(key=lambda x: int(x["year"]), reverse=True)
long_author.sort(key=lambda x: int(x["year"]), reverse=True)

with open("./sections/publications.tex", "w") as tex:

    tex.write("Short-author publications:\n\n")
    tex.write("\\begin{itemize}[noitemsep]\n")
    tex.write("{\n")

    for e in short_author:
        authors = format_authors(e["author"])
        title = clean_title(e["title"])
        arxiv = arxiv_link(e["eprint"])
        journal = journal_link(e)
        year = e["year"]

        line = f"    \\item {authors}, \\textit{{{title}}}"
        if journal:
            line += f", {journal}"
        line += f", {arxiv}. \\hfill {year}\n\n"
        tex.write(line)

    tex.write("}\n\\end{itemize}\n\n")

    tex.write("Selected long-author publications (with direct contribution):\n")
    tex.write("\\begin{itemize}[noitemsep]\n")

    for e in long_author:
        collab = normalize_collaboration(e["collaboration"])
        title = clean_title(e["title"])
        arxiv = arxiv_link(e["eprint"])
        journal = journal_link(e)
        year = e["year"]

        line = f"    \\item {collab} collaborations; \\textit{{{title}}}"
        if journal:
            line += f", {journal}"
        line += f", {arxiv}. \\hfill {year}\n\n"
        tex.write(line)

    tex.write("\\end{itemize}\n")

print("Generated ./sections/publications.tex")
