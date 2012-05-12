open Format
open Ast
open Term



let pp_sort2 fmt = function
  | AProp -> fprintf fmt "Prop"
  | AType n -> fprintf fmt "Type <%d>" n



let rec pp_astTerm fmt = function
  | AVar name        -> fprintf fmt "%s" name
  | ASort s          -> fprintf fmt "%a" pp_sort2 s
  | ALam  (s,t1, t2) -> 
    fprintf fmt "\\%s : (%a) . (%a)" s pp_astTerm t1 pp_astTerm t2
  | AApp  (t1 , t2) -> 
    fprintf fmt "[(%a) (%a)]" pp_astTerm t1 pp_astTerm t2
  | APi (s,t1,t2) -> 
    fprintf fmt "Pi %s : (%a) . (%a)" s pp_astTerm t1 pp_astTerm t2


let pp_sort fmt = function
  | Prop -> fprintf fmt "Prop"
  | Type (Uint n) -> fprintf fmt "Type <%d>" n
  | Type (Uvar x) -> fprintf fmt "Type <%s>" x



let rec pp_term fmt = function
  | Var name        -> fprintf fmt "%s" name
  | Sort s          -> fprintf fmt "%a" pp_sort s
  | Id n            -> fprintf fmt "%d" n
  | Lam  (t1, t2) -> 
    fprintf fmt "\\ (%a) . (%a)" pp_term t1 pp_term t2
  | App  (t1 , t2) -> 
    fprintf fmt "[(%a) (%a)]" pp_term t1 pp_term t2
  | Pi (t1,t2) -> 
    fprintf fmt "Pi (%a) . (%a)" pp_term t1 pp_term t2

let pp_global fmt = function
  | _                -> ()

