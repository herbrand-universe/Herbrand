(* ****************************************************************************
 *   Term solo deberia tener definiciones de tipos (creo):
 * El motivo principal es evitar inclusiones recursivas con otros archivos.
 * Cuando haya mas cosas, term.ml deberia desaparecer y ser solo term.mli
 * ***************************************************************************)
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
  | Lam   of term * term
  | App   of term * term
  | Pi    of term * term



val toDeBruijn : Ast.astTerm -> term

(** Weak Head Normal Form*)
(**)
val whnf : term -> term
val whnf_is_kind : term -> bool
val get_whnf_kind : term -> sort
val get_whnf_pi : term -> term * term
val dBsubs : int -> term -> term -> term

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

