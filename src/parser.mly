%{
  open Ast
  open Term
%}

/* Parser para Herbrand */
%token <string> IDENT
%token <int> NUM
%token DEF SHOW PROOF END ALL TEST
%token EQ CHECK WITH WHNF ID INFER SHOW QUIT
%token COLON DOT COMMA TSEP ARROW
%token LAM PI PROP TYPE SIGMA PAIR FST SND
%token AND OR IMP NOT EXISTS FORALL TRUE FALSE
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
|  DEF ident EQ term       { Gdef ($2,$4) }
|  PROOF ident EQ prop     { Gproof ($2,$4) }
|  END                     { Gend }
|  INFER term              { Ginfer $2 }
|  CHECK term WITH term    { Gcheck ($2,$4) }
|  WHNF term               { Gwhnf $2 }
|  SHOW ALL                { Gshow_all }
|  SHOW term               { Gshow $2 }
|  TEST                    { Gtest }
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
| SIGMA ident COLON term COMMA term   { ASigma ($2,$4,$6) }
| term ARROW term                  { APi ("1$",$1,$3)}
| LAM ident COLON term COMMA term  { ALam ($2,$4,$6) }
| term term                        { AApp ($1,$2) }
| FST term                         { AFst $2 }
| SND term                         { ASnd $2 }
;

number:
  NUM              { $1 }
;

ident:
  IDENT            { $1 }
;

prop:
| ident                                { Gvar $1 }
| LPAREN prop RPAREN                   { $2 }
| NOT prop                             { Gnot $2 }
| prop AND prop                        { Gand ($1,$3) }
| prop OR  prop                        { Gor  ($1,$3) }
| prop IMP prop                        { Gimp ($1,$3) }
| FORALL ident COLON term COMMA prop   { Gforall ($2,$4,$6) }
| EXISTS ident COLON term COMMA prop   { Gexists ($2,$4,$6) }
| TRUE	       	     	  	       { Gtrue }
| FALSE				       { Gfalse }
