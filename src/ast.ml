open Format
open Term

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
  | AEq    of astTerm * astTerm * astTerm


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

let pp_sort fmt = function
  | AProp -> fprintf fmt "Prop"
  | AType n -> fprintf fmt "Type <%d>" n

let rec freeVar n = function
  | AVar name when (n = name)        -> true
  | ASort s                          -> false
  | AApp   (s,t)                     -> (freeVar n s) || (freeVar n t)
  | ALam   (n1,s,t) when (n <> n1)   -> (freeVar n s) || (freeVar n t)
  | APi    (n1,s,t) when (n <> n1)   -> (freeVar n s) || (freeVar n t)
  | ASigma (n1,s,t) when (n <> n1)   -> (freeVar n s) || (freeVar n t)
  | AFst t                           -> freeVar n t 
  | ASnd t                           -> freeVar n t
  | APair (s,t1,t2)                  -> (freeVar n s) || (freeVar n t1) || (freeVar n t2) 
  | _                                -> false

let rec pp_astTerm fmt = function
  | AVar name        -> fprintf fmt "%s" name
  | ASort s          -> fprintf fmt "%a" pp_sort s
  | ALam  (s,t1, t2) -> 
    fprintf fmt "L %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2
  | AApp  (t1 , t2) -> 
    fprintf fmt "[(%a) (%a)]" pp_astTerm t1 pp_astTerm t2
  | APi (s,t1,t2) when (freeVar s t2) -> 
    fprintf fmt "P %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2
  | APi (s,t1,t2) -> 
    fprintf fmt "(%a) -> (%a)" pp_astTerm t1 pp_astTerm t2
  | ASigma (s,t1,t2) when (freeVar s t2) -> 
    fprintf fmt "S %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2
  | ASigma (s,t1,t2) -> 
    fprintf fmt "<%a,%a>" pp_astTerm t1 pp_astTerm t2
  | APair (s,t1,t2)  ->
    fprintf fmt "pair [%a][%a,%a]" pp_astTerm s pp_astTerm t1 pp_astTerm t2
  | AFst t  -> fprintf fmt "fst(%a)" pp_astTerm t
  | ASnd t  -> fprintf fmt "snd(%a)" pp_astTerm t

