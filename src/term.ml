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
  | Id    of int
  | Var   of name
  | Sort  of sort
  | Lam   of name * term * term
  | App   of term * term
  | Pi    of name * term * term



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

