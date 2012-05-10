
all:
	ocamlyacc parser.mly
	ocamllex  lexer.mll
	ocamlc -o herbrand term.mli term.ml ast.mli parser.mli parser.ml lexer.ml pretty.ml  main.ml 

clean:
	rm -Rf parser.ml parser.mli lexer.ml
	rm -Rf herbrand
	rm -Rf *.cmo *.cmi
