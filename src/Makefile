
all:
	ocamlyacc parser.mly
	ocamllex  lexer.mll
	ocamlc -o herbrand ast.mli ast.ml term.mli term.ml context.mli context.ml constraints.ml satisfiable.ml typechecker.mli typechecker.ml tests.ml parser.mli parser.ml lexer.ml main.ml 

clean:
	rm -Rf parser.ml parser.mli lexer.ml
	rm -Rf herbrand
	rm -Rf *.cmo *.cmi
