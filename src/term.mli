
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

type name = string

type universe_vars =
  | Uint of int
  | Uvar of name

type sort = 
  | Prop
  | Type of universe_vars

type term =
  | Var   of name
  | Sort  of sort
  | Lam   of name * term * term
  | App   of term * term
  | Pi    of name * term * term


type pair =
  | LT of name * name
  | GT of name * name
  | EQ of name * name
  | LE of name * name
  | GE of name * name

type level_assignment = (name * int) list

type constraints = pair list

