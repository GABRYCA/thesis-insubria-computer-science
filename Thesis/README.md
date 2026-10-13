# Build instructions

Prerequisites: TeX Live (`pdflatex`, `latexmk`, `biber`) and Python with
Pygments (required by the `minted` package for code listings).

Build all documents (thesis, 10-page synthesis, summary):

- Windows: run `build_pdf.bat`
- Git Bash / Linux: run `./build_pdf.sh` (or `bash build_pdf.sh`)

Final PDFs: `out/main.pdf`, `10pagine/out/main.pdf`, `riassunto/out/riassunto.pdf`
