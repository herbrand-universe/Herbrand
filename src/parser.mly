%{
  open Utils
  open Ast
  open Term

  let get_pos () = pos_of_lex (symbol_start_pos()) (symbol_end_pos())

  let parse_error msg = raise (ParseError (get_pos (), msg))

%}

/* Parser para Herbrand */
%token <string> IDENT
%token <int> NUM
%token DEF SHOW PROOF END ALL TEST VAR IND
%token EQ CHECK WITH WHNF ID INFER SHOW QUIT
%token COLON DOT COMMA TSEP ARROW
%token LAM PI PROP TYPE SIGMA PAIR FST SND
%token AND OR IMP NOT EXISTS FORALL TRUE FALSE
%token PLUS INR INL CASE EQLKEY LKEY RKEY
%token LPAREN RPAREN LBRACKET RBRACKET
%token LT GT
%token EOL
%start global
%type <Ast.global> global
%%

global: 
  global_elem DOT {$1}
;

global_elem:
|  VAR ident COLON term    { Gvar ($2,$4) }
|  DEF ident EQ term       { Gdef ($2,$4) }
|  IND ident COLON context WITH { Gind ($2,$4) }
|  PROOF ident EQ prop     { Gproof ($2,$4) }
|  END                     { Gend }
|  INFER term              { Ginfer $2 }
|  CHECK term WITH term    { Gcheck ($2,$4) }
|  WHNF term               { Gwhnf $2 }
|  SHOW ALL                { Gshow_all }
|  SHOW term               { Gshow $2 }
|  TEST                    { Gtest }
|  QUIT                    { Gquit }
|  error                   { parse_error "Command not found" }
;


sorts: 
| PROP             { AProp }
| TYPE TSEP number { AType $3 } 
;

term:
| LPAREN term RPAREN               { $2 } 
| ident                            { AVar $1 }
| sorts                            { ASort $1 }
| PI ident COLON term COMMA term   { APi ($2,$4,$6) }
| SIGMA ident COLON term COMMA term   { ASigma ($2,$4,$6) }
| term ARROW term                  { APi ("1$",$1,$3)}
| LAM ident COLON term COMMA term  { ALam ($2,$4,$6) }
| term term                        { AApp ($1,$2) }
| FST term                         { AFst $2 }
| SND term                         { ASnd $2 }
| INL LKEY term RKEY LKEY term RKEY          { AInl ($3,$6) }
| INR LKEY term RKEY LKEY term RKEY          { AInr ($3,$6) }
| term PLUS term                   { ASum ($1,$3) }
| term EQLKEY term RKEY term       { AEq ($3,$1,$5) }
;

number:
  NUM              { $1 }
;

ident:
  IDENT            { $1 }
;

prop:
| ident                                { Lvar $1 }
| LPAREN prop RPAREN                   { $2 }
| NOT prop                             { Lnot $2 }
| prop AND prop                        { Land ($1,$3) }
| prop OR  prop                        { Lor  ($1,$3) }
| prop IMP prop                        { Limp ($1,$3) }
| FORALL ident COLON term COMMA prop   { Lforall ($2,$4,$6) }
| EXISTS ident COLON term COMMA prop   { Lexists ($2,$4,$6) }
| TRUE	       	     	  	       { Ltrue }
| FALSE				       { Lfalse }
;

context:
|  empty                                      { [] }
|  LBRACKET ident COLON term RBRACKET context { ($2,$4) :: $6 }
;

empty:
| {}
;
