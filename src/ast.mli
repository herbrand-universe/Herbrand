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
  | ASigma of name * astTerm * astTerm
  | APair  of astTerm * astTerm * astTerm
  | AFst   of astTerm
  | ASnd   of astTerm


type prop =
  | Ltrue
  | Lfalse
  | Lvar of name
  | Lnot of prop
  | Land of prop * prop
  | Lor  of prop * prop
  | Limp of prop * prop
  | Lforall of name * astTerm * prop
  | Lexists of name * astTerm * prop


type global = 
  | Gdef     of name * astTerm
  | Gvar     of name * astTerm
  | Gproof   of name * prop
  | Gend
  | Ginfer   of astTerm
  | Gshow    of astTerm
  | Gshow_all
  | Gwhnf    of astTerm
  | Gcheck   of astTerm * astTerm
  | Gtest
  | Gquit 

val pp_astTerm : Format.formatter -> astTerm -> unit

