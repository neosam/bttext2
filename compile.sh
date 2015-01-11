#!/bin/bash

ocamlfind ocamlopt \
		-o lalala -linkpkg -package curses -thread -package threads \
		btio.mli btio.ml btdisplay.mli btdisplay.ml \
		Main.ml
