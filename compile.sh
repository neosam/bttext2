#!/bin/bash

ocamlfind ocamlopt \
		-o lalala -linkpkg -package curses -thread -package threads \
		btio.mli btio.ml \
		btgame.mli btgame.ml \
		btmessages.mli btmessages.ml \
		btdisplay.mli btdisplay.ml \
		Main.ml
