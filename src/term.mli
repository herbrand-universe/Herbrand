(* ****************************************************************************
 *   Term solo deberia tener definiciones de tipos (creo):
 * El motivo principal es evitar inclusiones recursivas con otros archivos.
 * Cuando haya mas cosas, term.ml deberia desaparecer y ser solo term.mli
 * ***************************************************************************)

(* ****************************************************************************
 * Syntax 
 *
 *  k  ::= Prop | Type a
 *
 *  T  ::=  x | k | \x:T.T | Pi x:T.T | [ X X ]
 *
 * ***************************************************************************)

type name = string

type sort = 
  | Prop
  | Type of int 

type term =
  | Id    of int
  | Var   of name
  | Sort  of sort
  | Lam   of term * term
  | App   of term * term
  | Pi    of term * term
  | Sigma of term * term
  | Pair  of term * term * term
  | Fst   of term
  | Snd   of term
  | Inl   of term * term
  | Inr   of term * term
  | Sum   of term * term


val pp_term : Format.formatter -> term -> unit
val toDeBruijn : Ast.astTerm -> term
val fromDeBruijn : term -> Ast.astTerm 

val dBsubs : int -> term -> term -> term


