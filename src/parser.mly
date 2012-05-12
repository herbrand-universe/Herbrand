%{
  open Ast
  open Term
%}

/* Parser para Herbrand */
%token <string> IDENT
%token <int> NUM
%token ASSUME EQ CHECK WITH WHNF ID INFER SHOW QUIT
%token COLON DOT COMMA TSEP
%token LAM PI PROP TYPE
%token LPAREN RPAREN
%token LT GT
%token EOL
%start global
%type <Ast.global> global
%%

global: 
  global_elem DOT {$1}
;

global_elem:
|  INFER term              { Ginfer $2 }
|  CHECK term WITH term    { Gcheck ($2,$4) }
|  WHNF term               { Gwhnf $2 }
|  SHOW term               { Gshow $2 }
|  QUIT                    { Gquit }
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
| LAM ident COLON term COMMA term  { ALam ($2,$4,$6) }
| term term                        { AApp ($1,$2) }
;

number:
  NUM              { $1 }
;

ident:
  IDENT            { $1 }
;
