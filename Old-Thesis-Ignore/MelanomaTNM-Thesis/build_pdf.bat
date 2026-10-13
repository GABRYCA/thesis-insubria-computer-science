@echo off
REM Build thesis PDF with latexmk (pdfLaTeX and biber) into out\main.pdf.
setlocal
cd /d "%~dp0"

where latexmk >nul 2>nul
if errorlevel 1 (
  echo ERROR: latexmk not found. Install TeX Live and make sure latexmk is on PATH.
  exit /b 1
)
where biber >nul 2>nul
if errorlevel 1 (
  echo ERROR: biber not found. Install TeX Live with biber.
  exit /b 1
)

echo [1/2] Cleaning previous build files...
latexmk -C -outdir=out main.tex >nul 2>nul
REM Remove stale files from old builds
del /q main.aux main.bbl main.bcf main.blg main.fdb_latexmk main.fls main.log main.out main.run.xml main.toc main.synctex.gz main.pdf compilation.log >nul 2>nul
del /q pdflatex*.fls >nul 2>nul
if exist "_minted" rmdir /s /q "_minted" >nul 2>nul

echo [2/2] Building out\main.pdf with latexmk ^(pdfLaTeX and biber^)...
latexmk -pdf -shell-escape -interaction=nonstopmode -outdir=out main.tex
if errorlevel 1 (
  echo ERROR: build failed. See out\main.log for details.
  exit /b 1
)

if exist "out\main.pdf" (
  echo Done. Final PDF: out\main.pdf
) else (
  echo ERROR: build finished but out\main.pdf was not created. See out\main.log.
  exit /b 1
)
