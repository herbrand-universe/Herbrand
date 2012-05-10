open Set
(* ****************************************************************************
 * Syntax 
 *
 *  l  ::= i | a
 *
 *  k  ::= Prop | Type a
 *
 *  T  ::=  x | k | \x:T.T | Pi x:T.T | [ X X ]
 *
 * ***************************************************************************)

type lvar = string
type name = string

type universe =
  | Uint of int
  | Uvar of lvar

type sort = 
  | Prop
  | Type of universe

type term =
  | Id    of int              (* Indices de deBrujin *)
  | Var   of name             (* Variables globales *)
  | Sort  of sort
  | Lam   of term * term
  | App   of term * term
  | Pi    of term * term



(* ****************************************************************************
 * val subs : name -> term -> term -> term
 * 
 * Se entiende como "subs v N M" es  "M[x/N]"
 *
 * Nota: Dado que las variables son unicamente globales, no se si tiene 
 *     sentido ahora tener sustitucion de variables
 * ***************************************************************************)
let rec subs v t = function
  | Var x          when (x = v)  -> t
  | Lam (t1,t2)   -> Lam (subs v t t1, subs v t t2)
  | Pi  (t1,t2)   -> Pi  (subs v t t1, subs v t t2)
  | App (t1,t2)   -> App (subs v t t1, subs v t t2)
  | term          -> term 





(*
type rel =
  | LT
  | LE
  | EQ
type constr =
  | C of rel * universe * universe

type level_assignment = (name * int) list


module LVar = struct
  type t = string 
  let compare = String.compare
end

module LVars = Set.Make( LVar )

module LConstraint = struct
  type t = constr 
  let compare _ _ = 1 
end

module LConstraints = Set.Make ( LConstraint )
*)

