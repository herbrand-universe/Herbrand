open Format
open Ast
open Term



let pp_sort fmt = function
  | AProp -> fprintf fmt "Prop"
  | AType n -> fprintf fmt "Type <%d>" n



let rec pp_term fmt = function
  | AVar name        -> fprintf fmt "%s" name
  | ASort s          -> fprintf fmt "%a" pp_sort s
  | ALam  (s,t1, t2) -> 
    fprintf fmt "\\%s : (%a) . (%a)" s pp_term t1 pp_term t2
  | AApp  (t1 , t2) -> 
    fprintf fmt "[(%a) (%a)]" pp_term t1 pp_term t2
  | APi (s,t1,t2) -> 
    fprintf fmt "Pi %s : (%a) . (%a)" s pp_term t1 pp_term t2


let pp_global fmt = function
  | _                -> ()

