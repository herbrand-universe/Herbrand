
all:
	ocamlyacc parser.mly
	ocamllex  lexer.mll
	ocamlc -o herbrand -rectypes  term.mli context.ml ast.mli parser.mli parser.ml lexer.ml pretty.ml  main.ml 

clean:
	rm -Rf parser.ml parser.mli lexer.ml
	rm -Rf *.cmo *.cmi
