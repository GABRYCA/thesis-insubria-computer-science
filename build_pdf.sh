#!/usr/bin/env bash
# Build thesis PDFs with latexmk (pdfLaTeX + biber).
# Builds the main thesis, the 10-page synthesis and the summary.
set -euo pipefail
cd "$(dirname "$0")"

command -v latexmk >/dev/null 2>&1 || { echo "ERROR: latexmk not found. Install TeX Live."; exit 1; }
command -v biber >/dev/null 2>&1 || { echo "ERROR: biber not found. Install TeX Live with biber."; exit 1; }

clean_doc() {
  # $1 = directory, $2 = main tex file
  ( cd "$1" && latexmk -C -auxdir=auxil -outdir=out "$2" >/dev/null 2>&1 ) || true
  rm -f "$1"/main.aux "$1"/main.bbl "$1"/main.bcf "$1"/main.blg "$1"/main.fdb_latexmk \
    "$1"/main.fls "$1"/main.log "$1"/main.out "$1"/main.run.xml "$1"/main.toc \
    "$1"/main.synctex.gz "$1"/riassunto.aux "$1"/riassunto.fdb_latexmk "$1"/riassunto.fls \
    "$1"/riassunto.log "$1"/riassunto.out "$1"/riassunto.synctex.gz \
    "$1"/compilation.log "$1"/pdflatex*.fls
  rm -rf "$1"/_minted
}

build_doc() {
  # $1 = directory, $2 = main tex file, $3 = expected PDF
  ( cd "$1" && latexmk -pdf -shell-escape -interaction=nonstopmode -auxdir=auxil -outdir=out "$2" )
  test -f "$3" || { echo "ERROR: build finished but $3 was not created."; exit 1; }
}

echo "[1/2] Cleaning previous build files..."
clean_doc . main.tex
clean_doc 10pagine main.tex
clean_doc riassunto riassunto.tex
# Remove stale files from old builds
rm -f main.aux main.bbl main.bcf main.blg main.fdb_latexmk main.fls main.log main.out \
  main.run.xml main.toc main.synctex.gz main.pdf compilation.log pdflatex*.fls
rm -f out/riassunto.aux out/riassunto.fdb_latexmk out/riassunto.fls out/riassunto.log \
  out/riassunto.out out/riassunto.synctex.gz
rm -rf _minted

echo "[2/2] Building PDFs with latexmk (pdfLaTeX + biber)..."
build_doc . main.tex out/main.pdf
build_doc 10pagine main.tex 10pagine/out/main.pdf
build_doc riassunto riassunto.tex riassunto/out/riassunto.pdf

echo "Done. Final PDFs: out/main.pdf, 10pagine/out/main.pdf, riassunto/out/riassunto.pdf"
