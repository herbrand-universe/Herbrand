open Format
open Ast
open Term


let pp_universe_vars fmt = function
  | Uint n -> fprintf fmt "%d" n
  | Uvar s -> fprintf fmt "%s" s


let pp_sort fmt = function
  | Prop -> fprintf fmt "Prop"
  | Type u -> fprintf fmt "Type <%a>" pp_universe_vars u



let rec pp_term fmt = function
  | Id  n           -> fprintf fmt "%d" n
  | Var name        -> fprintf fmt "%s" name
  | Sort s          -> fprintf fmt "%a" pp_sort s
  | Lam  (s,t1, t2) -> 
    fprintf fmt "\\%s : (%a) . (%a)" s pp_term t1 pp_term t2
  | App  (t1 , t2) -> 
    fprintf fmt "[(%a) (%a)]" pp_term t1 pp_term t2
  | Pi (s,t1,t2) -> 
    fprintf fmt "Pi %s : (%a) . (%a)" s pp_term t1 pp_term t2


let pp_global fmt = function
  | _                -> ()

