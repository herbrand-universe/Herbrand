%{
  open Ast
  open Term
%}

/* Parser para Herbrand */
%token <string> IDENT
%token <int> NUM
%token ASSUME EQ CHECK WHNF ID INFER SHOW QUIT
%token COLON DOT 
%token LAM PI PROP TYPE
%token LPAREN RPAREN
%token LBRACKET RBRACKET
%token LT GT
%token EOL
%start global
%type <Ast.global> global
%%

global: 
  global_elem EOL {$1}
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


universe_vars:
| LT number GT    { Uint $2 }
| LT ident  GT    { Uvar $2 }    
;

sorts: 
| PROP                         { Prop }
| TYPE universe_vars           { Type $2 } 
;

term:
| LPAREN term RPAREN             { $2 } 
| ident                          { Var $1 }
| sorts                          { Sort $1 }
| LAM ident COLON term DOT term  { Lam ($2,$4,$6) }
| LBRACKET term term RBRACKET    { App ($2,$3) }
| PI ident COLON term DOT term   { Pi ($2,$4,$6) }
;

number:
  NUM              { $1 }
;

ident:
  IDENT            { $1 }
;
