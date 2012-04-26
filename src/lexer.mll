{
open Parser
exception Eof

let keywords_symbols =
  [
    "Pi",      PI;
    "Prop",    PROP;
    "Type",    TYPE;
  ]

let tactics_keywords =
  [ ]

let global_keywords = 
  [
    "check",   CHECK;
    "whnf",    WHNF;
    "assume",  ASSUME;
    "show" ,   SHOW;
    "eq_term", EQ;
    "infer",   INFER;
    "quit" ,   QUIT;
  ]

let keywords = Hashtbl.create 30

let _ = 
  let add_ky = List.iter (fun (x,y) -> Hashtbl.add keywords x y) 
  in add_ky keywords_symbols;
     add_ky global_keywords;
     add_ky tactics_keywords

}

let blank = [' ' '\t' '\r' ]
let newline = '\n'
let letter =  ['a'-'z' '_'] | ['A'-'Z']
let digit =  ['0'-'9']
let number = digit+

let first_letter = letter
let other_letter = first_letter | '\''
let ident = first_letter other_letter*

rule token = parse
    blank+             { token lexbuf }
  | newline            { token lexbuf }
  | number             { NUM (int_of_string (Lexing.lexeme lexbuf))}
  | ident as id               {
        try Hashtbl.find keywords id with Not_found -> IDENT id }
  | '.'                { DOT }
  | ':'                { COLON }
  | '\\'               { LAM }
  (*Logic's symbols*)
  | '<'                { LT }
  | '>'                { GT }

  | '['                { LBRACKET }
  | ']'                { RBRACKET }

  | '('                { LPAREN }
  | ')'                { RPAREN }

  | '?'                { EOL }
  | eof                { raise Eof }