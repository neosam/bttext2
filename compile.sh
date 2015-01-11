#!/bin/bash

ocamlfind ocamlopt \
		-o lalala -linkpkg -package curses -thread -package threads \
		Terminal.mli Terminal.ml \
		Main.ml
