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
  | AInl   of astTerm * astTerm
  | AInr   of astTerm * astTerm
  | ASum   of astTerm * astTerm
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
  | Gind     of name * ((name * astTerm) list)
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
  | AType n -> fprintf fmt "Type/%d" n

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

let rec pp_astTerm fmt term =
  let pp a = fprintf fmt a in
  match term with
  | AVar name        -> pp "%s" name
  | ASort s          -> pp "%a" pp_sort s
  | ALam  (s,t1, t2) -> pp "L %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2
  | AApp  (t1 , t2)  ->  pp "[(%a) (%a)]" pp_astTerm t1 pp_astTerm t2
  | APi (s,t1,t2) when (freeVar s t2) -> pp "P %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2
  | APi (s,t1,t2)    ->  pp"(%a) -> (%a)" pp_astTerm t1 pp_astTerm t2
  | ASigma (s,t1,t2) when (freeVar s t2) -> pp "S %s : (%a), (%a)" s pp_astTerm t1 pp_astTerm t2
  | ASigma (s,t1,t2) -> pp "<%a,%a>" pp_astTerm t1 pp_astTerm t2
  | APair (s,t1,t2)  -> pp "pair [%a][%a,%a]" pp_astTerm s pp_astTerm t1 pp_astTerm t2
  | AFst t           -> pp "fst(%a)" pp_astTerm t
  | ASnd t           -> pp "snd(%a)" pp_astTerm t
  | AInl (c,t)       -> pp "inl(%a)" pp_astTerm t
  | AInr (c,t)       -> pp "inr(%a)" pp_astTerm t
  | ASum (a,b)       -> pp "((%a) + (%a))" pp_astTerm a pp_astTerm b

