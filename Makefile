OCAMLFIND=ocamlfind
OCAMLC=ocamlc
OCAMLOPT=ocamlopt

PACKAGE_CURSES=-package curses

BTIO_TEST_EXE=btiotest
BTIO_TEST_DEP=build/btio.cmx build/btiotest.cmx
BTRENDER_TEST_EXE=btrendertest
BTRENDER_TEST_DEP=build/btio.cmx build/btrender.cmx build/btrendertest.cmx

all: ${BTIO_TEST_EXE} ${BTRENDER_TEST_EXE}

clean:
	rm build/*
	rm ${BTIO_TEST_EXE} ${BTRENDER_TEST_EXE}

${BTIO_TEST_EXE}: ${BTIO_TEST_DEP}
	${OCAMLFIND} ${OCAMLOPT} -linkpkg -I build/ ${PACKAGE_CURSES} ${BTIO_TEST_DEP} -o ${BTIO_TEST_EXE}
${BTRENDER_TEST_EXE}: ${BTRENDER_TEST_DEP}
	${OCAMLFIND} ${OCAMLOPT} -linkpkg -I build/ ${PACKAGE_CURSES} ${BTRENDER_TEST_DEP} -o ${BTRENDER_TEST_EXE}

build/btio.cmi: src/btio.mli
	${OCAMLFIND} ${OCAMLOPT} -c -I build/ src/btio.mli -o build/btio.cmi

build/btio.cmx: src/btio.ml build/btio.cmi
	${OCAMLFIND} ${OCAMLOPT} -c -I build/ ${PACKAGE_CURSES} src/btio.ml -o build/btio.cmx

build/btiotest.cmx: src/btiotest.ml
	${OCAMLFIND} ${OCAMLOPT} -c -I build/ src/btiotest.ml -o build/btiotest.cmx

build/btrender.cmi: src/btrender.mli
	${OCAMLFIND} ${OCAMLOPT} -c -I build/ src/btrender.mli -o build/btrender.cmi

build/btrender.cmx: src/btrender.ml build/btrender.cmi
	${OCAMLFIND} ${OCAMLOPT} -c -I build/ ${PACKAGE_CURSES} src/btrender.ml -o build/btrender.cmx

build/btrendertest.cmx: src/btrendertest.ml
	${OCAMLFIND} ${OCAMLOPT} -c -I build/ src/btrendertest.ml -o build/btrendertest.cmx
