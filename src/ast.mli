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

val pp_astTerm : Format.formatter -> astTerm -> unit

