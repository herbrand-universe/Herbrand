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

type name = string

type sort = 
  | Prop
  | Type of int 

type term =
  | Id    of int              (* Indices de deBruijn *)
  | Var   of name             (* Variables globales *)
  | Sort  of sort
  | Lam   of term * term
  | App   of term * term
  | Pi    of term * term
  | Sigma of term * term
  | Pair  of term * term * term
  | Fst   of term
  | Snd   of term



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
  | Lam   (t1,t2)   -> Lam (subs v t t1, subs v t t2)
  | Pi    (t1,t2)   -> Pi  (subs v t t1, subs v t t2)
  | Sigma (t1,t2)   -> Sigma  (subs v t t1, subs v t t2)
  | App   (t1,t2)   -> App (subs v t t1, subs v t t2)
  | Pair  (s,t1,t2) -> Pair (subs v t s,subs v t t1, subs v t t2)
  | Fst s           -> Fst (subs v t s)
  | Snd s           -> Snd (subs v t s)
  | term            -> term 
  
  
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
  | Sigma  (ty,t1)     -> Sigma  (dBsubs n t ty, dBsubs (n+1) t t1)
  | Pair (s,t1,t2)     -> Pair (dBsubs n t s, dBsubs n t t1, dBsubs n t t2)
  | Fst s              -> Fst (dBsubs n t s)
  | Snd s              -> Snd (dBsubs n t s)
  | Sort s             -> Sort s

(* ****************************************************************************
 * Leibniz eq
 *        =A             is       \x : A, \y : A, Pi P : (A ->Prop), P x -> Py
 * ***************************************************************************)
let def_eq a = 
  let px = AApp (AVar "P",AVar "x") in
  let py = AApp (AVar "P",AVar "y") in
  let px_py = APi ("%$", px, py) in
  let a_prop = APi ("%%",a, ASort AProp) 
  in 
    ALam ("x",a,(ALam ("y",a,(APi ("P",a_prop,px_py)))))

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
    | ASort (AType n) -> Sort (Type n)
    | ALam (n, at, at') -> Lam (toDeBruijnCtx ctx at, toDeBruijnCtx (n::ctx) at')
    | APi (n, at, at') -> Pi (toDeBruijnCtx ctx at, toDeBruijnCtx (n::ctx) at')
    | ASigma (n, at, at') -> Sigma (toDeBruijnCtx ctx at, toDeBruijnCtx (n::ctx) at')
    | AApp (at, at') -> App (toDeBruijnCtx ctx at, toDeBruijnCtx ctx at')
    | APair (n,at,at') -> Pair(toDeBruijnCtx ctx n, toDeBruijnCtx ctx at, toDeBruijnCtx ctx at')
    | AFst at            -> Fst (toDeBruijnCtx ctx at)
    | ASnd at            -> Snd (toDeBruijnCtx ctx at)
    | AEq (a,s,t)        -> toDeBruijnCtx ctx (AApp (AApp (def_eq a, s),t))
  in toDeBruijnCtx []

let pp_sort fmt = function
  | Prop -> fprintf fmt "Prop"
  | Type n -> fprintf fmt "Type <%d>" n

let lastVar = ref 0
let freshVar () = incr lastVar; ("y" ^ string_of_int !lastVar)

let rec fromDeBruijn = function
  | Var name        -> AVar name
  | App (s,t)       -> AApp (fromDeBruijn s,fromDeBruijn t)
  | Sort Prop       -> ASort AProp
  | Id n            -> AVar (string_of_int n)
  | Sort (Type a)   -> ASort (AType a)
  | Pi  (s,t)       -> let n = freshVar () in APi (n,fromDeBruijn s, fromDeBruijn (dBsubs 1 (Var n) t))
  | Lam (s,t)       -> let n = freshVar () in ALam (n,fromDeBruijn s, fromDeBruijn (dBsubs 1 (Var n) t))
  | Sigma (s,t)     -> let n = freshVar () in ASigma (n,fromDeBruijn s, fromDeBruijn (dBsubs 1 (Var n) t))
  | Pair (s,t1,t2)  -> APair (fromDeBruijn s, fromDeBruijn t1, fromDeBruijn t2)
  | Fst t             -> AFst (fromDeBruijn t)
  | Snd t             -> ASnd (fromDeBruijn t)

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
