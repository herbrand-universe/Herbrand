
all:
	ocamlyacc parser.mly
	ocamllex  lexer.mll
	ocamlc -o herbrand ast.mli term.mli ast.ml term.ml logic.ml context.mli context.ml typechecker.mli typechecker.ml tests.ml parser.mli parser.ml lexer.ml main.ml 

clean:
	rm -Rf parser.ml parser.mli lexer.ml
	rm -Rf herbrand
	rm -Rf *.cmo *.cmi
