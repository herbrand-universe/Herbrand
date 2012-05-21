open Format

type name = string

type sort = 
  | AProp
  | AType of int 

type astTerm =
  | AVar   of name
  | ASort  of sort
  | ALam   of name * astTerm * astTerm
  | AApp   of astTerm * astTerm
  | APi    of name * astTerm * astTerm


type prop =
  | Gvar of name
  | Gnot of prop
  | Gand of prop * prop
  | Gor  of prop * prop
  | Gimp of prop * prop
  | Gforall of name * prop * prop
  | Gexists of name * prop * prop

type global = 
  | Gdef     of name * astTerm
  | Gproof   of name * prop
  | Gend
  | Ginfer   of astTerm
  | Gshow    of astTerm
  | Gshow_all
  | Gwhnf    of astTerm
  | Gcheck   of astTerm * astTerm
  | Gquit

let pp_sort fmt = function
  | AProp -> fprintf fmt "Prop"
  | AType n -> fprintf fmt "Type <%d>" n



let rec pp_astTerm fmt = function
  | AVar name        -> fprintf fmt "%s" name
  | ASort s          -> fprintf fmt "%a" pp_sort s
  | ALam  (s,t1, t2) -> 
    fprintf fmt "L %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2
  | AApp  (t1 , t2) -> 
    fprintf fmt "[(%a) (%a)]" pp_astTerm t1 pp_astTerm t2
  | APi (s,t1,t2) -> 
    fprintf fmt "P %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2

