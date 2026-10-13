@echo off
REM Build thesis PDFs with latexmk (pdfLaTeX and biber).
REM Builds the main thesis, the 10-page synthesis and the summary.
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
call :clean . main.tex
call :clean 10pagine main.tex
call :clean riassunto riassunto.tex
REM Remove stale files from old builds
del /q main.aux main.bbl main.bcf main.blg main.fdb_latexmk main.fls main.log main.out main.run.xml main.toc main.synctex.gz main.pdf compilation.log >nul 2>nul
del /q pdflatex*.fls >nul 2>nul
del /q out\riassunto.aux out\riassunto.fdb_latexmk out\riassunto.fls out\riassunto.log out\riassunto.out out\riassunto.synctex.gz >nul 2>nul
if exist "_minted" rmdir /s /q "_minted" >nul 2>nul

echo [2/2] Building PDFs with latexmk ^(pdfLaTeX and biber^)...
call :build . main.tex out\main.pdf
if errorlevel 1 exit /b 1
call :build 10pagine main.tex 10pagine\out\main.pdf
if errorlevel 1 exit /b 1
call :build riassunto riassunto.tex riassunto\out\riassunto.pdf
if errorlevel 1 exit /b 1

echo Done. Final PDFs: out\main.pdf, 10pagine\out\main.pdf, riassunto\out\riassunto.pdf
exit /b 0

:clean
pushd "%~1"
latexmk -C -auxdir=auxil -outdir=out "%~2" >nul 2>nul
del /q main.aux main.bbl main.bcf main.blg main.fdb_latexmk main.fls main.log main.out main.run.xml main.toc main.synctex.gz riassunto.aux riassunto.fdb_latexmk riassunto.fls riassunto.log riassunto.out riassunto.synctex.gz compilation.log >nul 2>nul
del /q pdflatex*.fls >nul 2>nul
if exist "_minted" rmdir /s /q "_minted" >nul 2>nul
popd
exit /b 0

:build
pushd "%~1"
latexmk -pdf -shell-escape -interaction=nonstopmode -auxdir=auxil -outdir=out "%~2"
if errorlevel 1 (
  echo ERROR: build failed for %~1\%~2. See %~1\auxil\%~n2.log for details.
  popd
  exit /b 1
)
popd
if not exist "%~3" (
  echo ERROR: build finished but %~3 was not created.
  exit /b 1
)
exit /b 0
