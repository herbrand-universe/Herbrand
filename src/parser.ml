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

open Parsing;;
# 2 "parser.mly"
  open Ast
  open Term
# 31 "parser.ml"
let yytransl_const = [|
  259 (* ASSUME *);
  260 (* EQ *);
  261 (* CHECK *);
  262 (* WHNF *);
  263 (* ID *);
  264 (* INFER *);
  265 (* SHOW *);
  266 (* QUIT *);
  267 (* COLON *);
  268 (* DOT *);
  269 (* COMMA *);
  270 (* TSEP *);
  271 (* LAM *);
  272 (* PI *);
  273 (* PROP *);
  274 (* TYPE *);
  275 (* LPAREN *);
  276 (* RPAREN *);
  277 (* LT *);
  278 (* GT *);
  279 (* EOL *);
    0|]

let yytransl_block = [|
  257 (* IDENT *);
  258 (* NUM *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\005\000\005\000\003\000\003\000\003\000\003\000\003\000\003\000\
\006\000\004\000\000\000"

let yylen = "\002\000\
\002\000\002\000\003\000\003\000\002\000\002\000\004\000\001\000\
\001\000\003\000\003\000\001\000\001\000\006\000\006\000\002\000\
\001\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\008\000\019\000\000\000\018\000\000\000\000\000\000\000\009\000\
\000\000\000\000\000\000\012\000\013\000\000\000\000\000\000\000\
\006\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\017\000\010\000\011\000\
\000\000\000\000\000\000\000\000\000\000\000\000"

let yydgoto = "\002\000\
\010\000\011\000\034\000\020\000\021\000\039\000"

let yysindex = "\006\000\
\070\255\000\000\005\255\042\255\042\255\042\255\042\255\005\255\
\000\000\000\000\253\254\000\000\000\255\005\255\005\255\000\000\
\002\255\042\255\042\255\000\000\000\000\042\255\042\255\042\255\
\000\000\000\000\042\255\006\255\010\255\020\255\009\255\042\255\
\042\255\042\255\042\255\042\255\042\255\000\000\000\000\000\000\
\029\255\036\255\042\255\042\255\042\255\042\255"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\019\255\022\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\023\255\
\024\255\248\254\026\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\050\255\052\255"

let yygindex = "\000\000\
\000\000\000\000\252\255\005\000\000\000\000\000"

let yytablesize = 80
let yytable = "\019\000\
\022\000\023\000\024\000\016\000\016\000\012\000\001\000\013\000\
\026\000\012\000\027\000\016\000\025\000\031\000\032\000\030\000\
\036\000\033\000\028\000\029\000\037\000\038\000\035\000\014\000\
\015\000\016\000\017\000\018\000\040\000\012\000\005\000\041\000\
\042\000\002\000\003\000\004\000\012\000\007\000\045\000\046\000\
\000\000\043\000\012\000\014\000\015\000\016\000\017\000\018\000\
\044\000\000\000\014\000\015\000\016\000\017\000\018\000\000\000\
\014\000\015\000\016\000\017\000\018\000\015\000\015\000\014\000\
\014\000\000\000\000\000\000\000\000\000\015\000\000\000\014\000\
\003\000\004\000\005\000\006\000\000\000\007\000\008\000\009\000"

let yycheck = "\004\000\
\005\000\006\000\007\000\012\001\013\001\001\001\001\000\003\000\
\012\001\001\001\011\001\020\001\008\000\018\000\019\000\014\001\
\011\001\022\000\014\000\015\000\011\001\002\001\027\000\015\001\
\016\001\017\001\018\001\019\001\020\001\001\001\012\001\036\000\
\037\000\012\001\012\001\012\001\001\001\012\001\043\000\044\000\
\255\255\013\001\001\001\015\001\016\001\017\001\018\001\019\001\
\013\001\255\255\015\001\016\001\017\001\018\001\019\001\255\255\
\015\001\016\001\017\001\018\001\019\001\012\001\013\001\012\001\
\013\001\255\255\255\255\255\255\255\255\020\001\255\255\020\001\
\003\001\004\001\005\001\006\001\255\255\008\001\009\001\010\001"

let yynames_const = "\
  ASSUME\000\
  EQ\000\
  CHECK\000\
  WHNF\000\
  ID\000\
  INFER\000\
  SHOW\000\
  QUIT\000\
  COLON\000\
  DOT\000\
  COMMA\000\
  TSEP\000\
  LAM\000\
  PI\000\
  PROP\000\
  TYPE\000\
  LPAREN\000\
  RPAREN\000\
  LT\000\
  GT\000\
  EOL\000\
  "

let yynames_block = "\
  IDENT\000\
  NUM\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'global_elem) in
    Obj.repr(
# 20 "parser.mly"
                  (_1)
# 162 "parser.ml"
               : Ast.global))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 24 "parser.mly"
                           ( Ginfer _2 )
# 169 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'term) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 25 "parser.mly"
                           ( Geq_term (_2,_3) )
# 177 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'term) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 26 "parser.mly"
                           ( Gcheck (_2,_3) )
# 185 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 27 "parser.mly"
                           ( Gwhnf _2 )
# 192 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ident) in
    Obj.repr(
# 28 "parser.mly"
                           ( Gshow _2 )
# 199 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'ident) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 29 "parser.mly"
                           ( Gassume (_2,_4) )
# 207 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    Obj.repr(
# 30 "parser.mly"
                      ( Gquit )
# 213 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    Obj.repr(
# 35 "parser.mly"
                   ( Prop )
# 219 "parser.ml"
               : 'sorts))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'number) in
    Obj.repr(
# 36 "parser.mly"
                   ( Type (Uint _3) )
# 226 "parser.ml"
               : 'sorts))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'term) in
    Obj.repr(
# 40 "parser.mly"
                                   ( _2 )
# 233 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ident) in
    Obj.repr(
# 41 "parser.mly"
                                   ( Var _1 )
# 240 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'sorts) in
    Obj.repr(
# 42 "parser.mly"
                                   ( Sort _1 )
# 247 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'ident) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 43 "parser.mly"
                                   ( Pi (_2,_4,_6) )
# 256 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'ident) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 44 "parser.mly"
                                   ( Lam (_2,_4,_6) )
# 265 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'term) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 45 "parser.mly"
                                   ( App (_1,_2) )
# 273 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 49 "parser.mly"
                   ( _1 )
# 280 "parser.ml"
               : 'number))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 53 "parser.mly"
                   ( _1 )
# 287 "parser.ml"
               : 'ident))
(* Entry global *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let global (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.global)
