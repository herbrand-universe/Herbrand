(* ****************************************************************************
 *   Term solo deberia tener definiciones de tipos (creo):
 * El motivo principal es evitar inclusiones recursivas con otros archivos.
 * Cuando haya mas cosas, term.ml deberia desaparecer y ser solo term.mli
 * ***************************************************************************)
open Ast
open Format
(* ****************************************************************************
 * Syntax 
 *
 *  l  ::= i | a
 *
 *  k  ::= Prop | Type a
 *
 *  T  ::=  x | k | L T,T | Pi T,T | [ X X ]
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
  | Id    of int              (* Indices de deBruijn *)
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
  
  
(* ****************************************************************************
 * val dBsubs : int -> term -> term -> term
 *
 * Nota: Ver el tema de la sustitucion adentro de los tipos de Lam y Pi 
 *     (en el primer argumento), no se si deberia o no incrementar n.
 * ***************************************************************************)
let rec dBsubs n t = function
  | Var x              -> Var x
  | App (t1,t2)        -> App ((dBsubs n t t1) ,(dBsubs n t t2))
  | Id k  when (k = n) -> t
  | Id k               -> Id k
  | Lam (ty,t1)        -> Lam (dBsubs n t ty, dBsubs (n+1) t t1) 
  | Pi  (ty,t1)        -> Pi  (dBsubs n t ty, dBsubs (n+1) t t1)
  | Sort s             -> Sort s


(* ****************************************************************************
 * val toDeBruijn : astTerm -> term
 *
 * Nota: \x -> x = \ 1  (Los indices empiezan en 1)
 * ***************************************************************************)
let toDeBruijn =
  let rec index_of e i = function
    | [] -> None
    | x :: xs -> if x = e then Some i else index_of e (i+1) xs
  in
  let rec toDeBruijnCtx ctx = function
    | AVar n -> (match index_of n 1 ctx with
      | None -> Var n
      | Some i -> Id i)
    | ASort AProp -> Sort Prop
    | ASort (AType n) -> Sort (Type (Uint n))
    | ALam (n, at, at') -> Lam (toDeBruijnCtx ctx at, toDeBruijnCtx (n::ctx) at')
    | APi (n, at, at') -> Pi (toDeBruijnCtx ctx at, toDeBruijnCtx (n::ctx) at')
    | AApp (at, at') -> App (toDeBruijnCtx ctx at, toDeBruijnCtx ctx at')
  in toDeBruijnCtx []

let pp_sort fmt = function
  | Prop -> fprintf fmt "Prop"
  | Type (Uint n) -> fprintf fmt "Type <%d>" n
  | Type (Uvar x) -> fprintf fmt "Type <%s>" x



let rec pp_term fmt = function
  | Var name        -> fprintf fmt "%s" name
  | Sort s          -> fprintf fmt "%a" pp_sort s
  | Id n            -> fprintf fmt "%d" n
  | Lam  (t1, t2) -> 
    fprintf fmt "L (%a) , (%a)" pp_term t1 pp_term t2
  | App  (t1 , t2) -> 
    fprintf fmt "[(%a) (%a)]" pp_term t1 pp_term t2
  | Pi (t1,t2) -> 
    fprintf fmt "P (%a) , (%a)" pp_term t1 pp_term t2
