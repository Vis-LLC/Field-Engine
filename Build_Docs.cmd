#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out
haxe  -cp src -D doc-gen --macro include('com.field') --no-output -xml doc.xml
haxelib run dox --toplevel-package com.field -i doc.xml -o pages --title "FieldEngine"
pushd doc-src
pdflatex fieldengine.tex
make4ht -c htlatex.cfg fieldengine.tex "xhtml,NoFonts,-css"
del *.aux
del *.log
del *.dvi
del *.idv
del *.lg
del *.tmp
del *.xref
del *.4ct
del *.4tc
del *.fls
del *.fdb_latexmk
move *.pdf ..\out
move *.html ..\out
move *.css ..\out
popd
popd
