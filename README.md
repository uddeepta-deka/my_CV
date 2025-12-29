[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/uddeepta-deka/my_CV/blob/main/LICENSE)
[![Build Status](https://github.com/uddeepta-deka/my_CV/actions/workflows/create_pdf.yml/badge.svg)](https://github.com/uddeepta-deka/my_CV/actions/workflows/create_pdf.yml)

# LaTeX based CV
Build CV using [GITHUB actions](https://github.com/features/actions). The output PDF is obtained as a [release version](https://github.com/uddeepta-deka/my_CV/releases/).

To generate your own CV
- Clone this repository.
- Modify the items in the [sections](https://github.com/uddeepta-deka/my_CV/tree/main/sections) folder. Additionally, modify the [`main.tex`](https://github.com/uddeepta-deka/my_CV/blob/main/main.tex) file.
- Generate a [Personal Access Token](https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) with at least `repo` scope.
- Copy the Token to a [new repository secret](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) and name it `RELEASE_TOKEN`.
- Commit your changes.

Adding publications:
- add your publications in publications.bib
- run `python generate_publications_tex.py` to generate the publications.tex file.
