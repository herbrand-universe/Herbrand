%{
  open Ast
  open Term
%}

/* Parser para Herbrand */
%token <string> IDENT
%token <int> NUM
%token ASSUME EQ CHECK WHNF ID INFER SHOW QUIT
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
|  EQ term term            { Geq_term ($2,$3) }
|  CHECK term term         { Gcheck ($2,$3) }
|  WHNF term               { Gwhnf $2 }
|  SHOW ident              { Gshow $2 }
|  ASSUME ident COLON term { Gassume ($2,$4) }
|  QUIT               { Gquit }
;


sorts: 
| PROP             { Prop }
| TYPE TSEP number { Type (Uint $3) } 
;

term:
| LPAREN term RPAREN               { $2 } 
| ident                            { Var $1 }
| sorts                            { Sort $1 }
| PI ident COLON term COMMA term   { Pi ($2,$4,$6) }
| LAM ident COLON term COMMA term  { Lam ($2,$4,$6) }
| term term                        { App ($1,$2) }
;

number:
  NUM              { $1 }
;

ident:
  IDENT            { $1 }
;
