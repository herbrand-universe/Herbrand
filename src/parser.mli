type token =
  | IDENT of (string)
  | NUM of (int)
  | ASSUME
  | EQ
  | CHECK
  | WHNF
  | ID
  | INFER
  | SHOW
  | QUIT
  | COLON
  | DOT
  | COMMA
  | TSEP
  | LAM
  | PI
  | PROP
  | TYPE
  | LPAREN
  | RPAREN
  | LT
  | GT
  | EOL

val global :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.global
