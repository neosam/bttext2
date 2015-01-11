#!/bin/bash

ocamlfind ocamlopt \
		-o lalala -linkpkg -package curses -thread -package threads -package str \
		btio.mli btio.ml \
		btgame.mli btgame.ml \
		btmessages.mli btmessages.ml \
		btdisplay.mli btdisplay.ml \
		Main.ml
