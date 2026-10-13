#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

command -v latexmk >/dev/null 2>&1 || { echo "ERROR: latexmk not found. Install TeX Live."; exit 1; }
command -v biber >/dev/null 2>&1 || { echo "ERROR: biber not found. Install TeX Live with biber."; exit 1; }

echo "[1/2] Cleaning previous build files..."
latexmk -C -outdir=out main.tex >/dev/null 2>&1 || true
rm -f main.aux main.bbl main.bcf main.blg main.fdb_latexmk main.fls main.log main.out main.run.xml main.toc main.synctex.gz main.pdf compilation.log pdflatex*.fls
rm -rf _minted

echo "[2/2] Building out/main.pdf with latexmk (pdfLaTeX + biber)..."
latexmk -pdf -shell-escape -interaction=nonstopmode -outdir=out main.tex

echo "Done. Final PDF: out/main.pdf"
