OCAMLFIND=ocamlfind
OCAMLC=ocamlc
OCAMLOPT=ocamlopt

PACKAGE_CURSES=-package curses

TEST_EXE=test
TEST_DEP=build/btio.cmx build/test.cmx

all: ${TEST_EXE}

clean:
	rm build/*

${TEST_EXE}: ${TEST_DEP}
	${OCAMLFIND} ${OCAMLOPT} -linkpkg -I build/ ${PACKAGE_CURSES} ${TEST_DEP} -o ${TEST_EXE}

build/btio.cmi: src/btio.mli
	${OCAMLFIND} ${OCAMLOPT} -c -I build/ src/btio.mli -o build/btio.cmi

build/btio.cmx: src/btio.ml build/btio.cmi
	${OCAMLFIND} ${OCAMLOPT} -c -I build/ ${PACKAGE_CURSES} src/btio.ml -o build/btio.cmx

build/test.cmx: src/test.ml
	${OCAMLFIND} ${OCAMLOPT} -c -I build/ src/test.ml -o build/test.cmx

