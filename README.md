[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/uddeepta-deka/my_CV/blob/main/LICENSE)
[![Build Status](https://github.com/uddeepta-deka/my_CV/actions/workflows/create_pdf.yml/badge.svg)](https://github.com/uddeepta-deka/my_CV/actions/workflows/create_pdf.yml)

# LaTeX-based CV

The CV is built by [GitHub Actions](https://github.com/features/actions), and the resulting PDF is available from the repository's [releases](https://github.com/uddeepta-deka/my_CV/releases/).

## Edit the CV

- Edit the relevant file in `sections/` for ordinary CV content.
- Edit only `sections/publications.bib` to add or update publications.
- Mark a collaboration or other long-author paper with `keywords = "long-author"` in its BibTeX entry. Those papers are placed in their own list automatically.
- Author names matching `Deka, Uddeepta` are bolded automatically.
- Publications are sorted in reverse chronological order.

## Build locally

Run the same four commands used by the automated build:

```sh
pdflatex -jobname=resume main.tex
bibtex resume
pdflatex -jobname=resume main.tex
pdflatex -jobname=resume main.tex
```

To publish releases from your own repository, create a repository secret named `RELEASE_TOKEN` containing a GitHub personal access token with repository access.
