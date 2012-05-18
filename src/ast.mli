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

type global = 
  | Gassume  of (name * astTerm)
  | Ginfer   of astTerm
  | Gshow    of astTerm
  | Gwhnf    of astTerm
  | Gcheck   of astTerm * astTerm
  | Gquit 

val pp_astTerm : Format.formatter -> astTerm -> unit

