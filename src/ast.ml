open Format
open Term

type name = string
type universe =
  | AUint of int
  | AUvar of string

type sort = 
  | AProp
  | AType of universe

type astTerm =
  | AVar   of name
  | ASort  of sort
  | ALam   of name * astTerm * astTerm
  | AApp   of astTerm * astTerm
  | APi    of name * astTerm * astTerm


type prop =
  | Gtrue
  | Gfalse
  | Gvar of name
  | Gnot of prop
  | Gand of prop * prop
  | Gor  of prop * prop
  | Gimp of prop * prop
  | Gforall of name * astTerm * prop
  | Gexists of name * astTerm * prop

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
  | AType (AUint n) -> fprintf fmt "Type <%d>" n
  | AType (AUvar n) -> fprintf fmt "Type <%s>" n

let rec freeVar n = function
  | AVar name when (n = name)      -> true
  | ASort s                        -> false
  | AApp (s,t)                     -> (freeVar n s) && (freeVar n t)
  | ALam (n1,s,t) when (n <> n1)   -> (freeVar n s) && (freeVar n t)
  | APi  (n1,s,t) when (n <> n1)   -> (freeVar n s) && (freeVar n t)
  | _                              -> false

let rec pp_astTerm fmt = function
  | AVar name        -> fprintf fmt "%s" name
  | ASort s          -> fprintf fmt "%a" pp_sort s
  | ALam  (s,t1, t2) -> 
    fprintf fmt "L %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2
  | AApp  (t1 , t2) -> 
    fprintf fmt "[(%a) (%a)]" pp_astTerm t1 pp_astTerm t2
  | APi (s,t1,t2) when not (freeVar s t2) -> 
    fprintf fmt "(%a) -> (%a)" pp_astTerm t1 pp_astTerm t2
  | APi (s,t1,t2) -> 
    fprintf fmt "P %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2

