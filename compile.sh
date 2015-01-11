#!/bin/bash

ocamlfind ocamlopt \
		-o lalala -linkpkg -package curses -thread -package threads \
		btio.mli btio.ml \
		Main.ml
