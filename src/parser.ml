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
\001\000\002\000\002\000\002\000\002\000\002\000\004\000\004\000\
\003\000\003\000\003\000\003\000\003\000\003\000\005\000\006\000\
\000\000"

let yylen = "\002\000\
\002\000\002\000\003\000\002\000\002\000\001\000\001\000\003\000\
\003\000\001\000\001\000\006\000\006\000\002\000\001\000\001\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\006\000\017\000\
\000\000\016\000\000\000\000\000\007\000\000\000\000\000\000\000\
\011\000\010\000\000\000\000\000\000\000\001\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\015\000\008\000\
\009\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yydgoto = "\002\000\
\008\000\009\000\028\000\017\000\032\000\018\000"

let yysindex = "\004\000\
\053\255\000\000\036\255\036\255\036\255\036\255\000\000\000\000\
\005\255\000\000\014\255\014\255\000\000\011\255\036\255\036\255\
\000\000\000\000\036\255\036\255\036\255\000\000\017\255\018\255\
\028\255\003\255\036\255\036\255\036\255\036\255\000\000\000\000\
\000\000\023\255\030\255\036\255\036\255\036\255\036\255"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\020\255\032\255\038\255\000\000\000\000\000\000\
\000\000\000\000\048\255\250\254\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\252\254\044\255"

let yygindex = "\000\000\
\000\000\000\000\253\255\000\000\000\000\255\255"

let yytablesize = 64
let yytable = "\016\000\
\019\000\020\000\021\000\010\000\001\000\014\000\014\000\013\000\
\013\000\023\000\024\000\026\000\027\000\014\000\010\000\013\000\
\022\000\011\000\012\000\013\000\014\000\015\000\033\000\010\000\
\025\000\034\000\035\000\029\000\030\000\031\000\010\000\004\000\
\038\000\039\000\000\000\036\000\010\000\011\000\012\000\013\000\
\014\000\015\000\037\000\002\000\011\000\012\000\013\000\014\000\
\015\000\005\000\011\000\012\000\013\000\014\000\015\000\012\000\
\012\000\003\000\004\000\003\000\005\000\006\000\007\000\012\000"

let yycheck = "\003\000\
\004\000\005\000\006\000\001\001\001\000\012\001\013\001\012\001\
\013\001\011\000\012\000\015\000\016\000\020\001\001\001\020\001\
\012\001\015\001\016\001\017\001\018\001\019\001\020\001\001\001\
\014\001\029\000\030\000\011\001\011\001\002\001\001\001\012\001\
\036\000\037\000\255\255\013\001\001\001\015\001\016\001\017\001\
\018\001\019\001\013\001\012\001\015\001\016\001\017\001\018\001\
\019\001\012\001\015\001\016\001\017\001\018\001\019\001\012\001\
\013\001\005\001\006\001\012\001\008\001\009\001\010\001\020\001"

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
# 155 "parser.ml"
               : Ast.global))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 24 "parser.mly"
                           ( Ginfer _2 )
# 162 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'term) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 25 "parser.mly"
                           ( Gcheck (_2,_3) )
# 170 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 26 "parser.mly"
                           ( Gwhnf _2 )
# 177 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 27 "parser.mly"
                           ( Gshow _2 )
# 184 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    Obj.repr(
# 28 "parser.mly"
                           ( Gquit )
# 190 "parser.ml"
               : 'global_elem))
; (fun __caml_parser_env ->
    Obj.repr(
# 33 "parser.mly"
                   ( AProp )
# 196 "parser.ml"
               : 'sorts))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'number) in
    Obj.repr(
# 34 "parser.mly"
                   ( AType _3 )
# 203 "parser.ml"
               : 'sorts))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'term) in
    Obj.repr(
# 38 "parser.mly"
                                   ( _2 )
# 210 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ident) in
    Obj.repr(
# 39 "parser.mly"
                                   ( AVar _1 )
# 217 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'sorts) in
    Obj.repr(
# 40 "parser.mly"
                                   ( ASort _1 )
# 224 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'ident) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 41 "parser.mly"
                                   ( APi (_2,_4,_6) )
# 233 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'ident) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 42 "parser.mly"
                                   ( ALam (_2,_4,_6) )
# 242 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'term) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 43 "parser.mly"
                                   ( AApp (_1,_2) )
# 250 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 47 "parser.mly"
                   ( _1 )
# 257 "parser.ml"
               : 'number))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 51 "parser.mly"
                   ( _1 )
# 264 "parser.ml"
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
