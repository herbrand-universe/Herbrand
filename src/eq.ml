open Term
open Context
exception Cannot_convert

let rec subs v t term =  match term with
  | Sort u                       -> Sort u
  | App (t1,t2)                  -> App ((subs v t t1) ,(subs v t t2))
  | Var x          when (x = v)  -> t
  | Lam (s,t1,t2)  when (s <> v) -> Lam (s,subs v t t1,subs v t t2) 
  | Pi (s,t1,t2)   when (s <> v) -> Pi (s,subs v t t1,subs v t t2)
  | Pi (s,t1,t2)                 -> Pi (s,t1,t2)
  | Var x                        -> Var x
  | Lam (s,t1,t2)                -> Lam (s,t1,t2) 


let rec whnf = function 
  | Var x                              -> Var x
  | Sort u                             -> Sort u
  | Lam (s,t1,t2)                      -> Lam (s,t1,t2)
  | App (Lam (s,_,t2) ,t1)             -> whnf (subs s t2 t1)
  | App (t1 ,t2) when (t1 = whnf (t1)) -> App (t1,t2)
  | App (t1, t2)                       -> whnf( App (whnf t1,t2))
  | Pi (s,t1,t2)                       -> Pi (s,t1,t2)



let rec conv t1 t2 = match whnf t1,whnf t2 with
  | Sort (Type (Uvar a)), Sort (Type (Uvar u)) -> [LE (a,u); GE (a,u)]
  | Sort Prop, Sort Prop -> []
  | Var y , Var x when (x = y) -> []

  (* ESTAS REGLAS ROMPEN LA ALFA CONVERCION, USAR SUBS*)
  | Lam (_,t1,t2), Lam (_,t3,t4) ->  (conv t1 t3) @ (conv t2 t4)
  | Pi (_,t1,t2), Pi (_,t3,t4) ->  (conv t1 t3) @ (conv t2 t4)

  | App (t1,t2), App (t3,t4) ->  (conv t1 t3) @ (conv t2 t4)
  | _ -> raise Cannot_convert




(*
(** Implementation of equivalence of kinds, types and terms 
 * Two terms are equivalents if they are alfa, beta, eta 
 * equivalents  *)

(*TODO: Check the usuals proofs with DeBrujin index *)

(** Substitution DeBrujin index with terms *)
let rec subs n t term =  match term with
  | Var x              -> Var x
  | App (t1,t2)        -> App ((subs n t t1) ,(subs n t t2))
  | Id k  when (k = n) -> t
  | Id k               -> Id k
  | Abs (ty,t1)        -> Abs (subs_type (n+1) t ty,subs (n+1) t t1) 
  | All (ty,t1)        -> All (subs_type (n+1) t ty,subs (n+1) t t1)

(** Extension for types and kinds *)
and  subs_type n t = function
  | Prop               -> Prop
  | Prf                -> Prf
  | TVar x             -> TVar x
  | TProd (t1,t2)      -> TProd (subs_type (n+1) t t1, subs_type (n+1) t t2)
  | TApp (t1,t')        -> TApp (subs_type n t t1, subs n t t')

let rec subs_kind n t = function
  | Star               -> Star
  | KProd (s1,k)       -> KProd (subs_type (n+1) t s1, subs_kind (n+1) t k)



(** Weak head normal form of terms *)
(* When the term is 'App (Abs ...)' the function beta-reduce
 * without check the types of the expression .... i don't 
 * understant very well *)
let rec whnf = function 
  | Var x                              -> Var x
  | Id n                               -> Id n
  | Abs (ty,t)                         -> Abs (ty,t)
  | App (Abs (ty,t) ,t2)               -> subs 0 t2 t
  | App (t1 ,t2) when (t1 = whnf (t1)) -> App (t1,t2)
  | App (t1, t2)                       -> whnf( App (whnf t1,t2))
  | All (ty,t)                         -> All (ty,whnf t)

(** Kind equivalence *)
let rec eq_kind c = function
  | (Star, Star)                 -> true
  | (KProd (t1,k1),KProd (t2,k2)) -> 
    let c' = assume_type t1 c in
      (eq_type c (t1,t2)) && (eq_kind c' (k1,k2))
  | _                            -> false

(** Type equivalence *)
and eq_type c = function
  | (TVar s1,TVar s2)              -> (s1 = s2)
  | (TProd (s1,s2), TProd (t1,t2)) ->
    let c' = assume_type s1 c in
      (eq_type c (s1,t1)) && (eq_type c' (s2,t2))

  | (TProd (s1,s2) , TApp (Prf,t)) ->
    let c' = assume_type s1 c in
      (match whnf t with
        | All (ty1,t1) ->
          (eq_type c (s1,ty1)) && (eq_type c' (s2, TApp (Prf, t1)))
        | _ -> false)

  | (TApp (Prf,t), TProd (s1,s2)) ->
     eq_type c (TProd (s1,s2), TApp (Prf,t))

  | (Prf , Prf ) -> true  
  | (Prop,Prop) -> true

  | (TApp (s1,t),TApp (s2,t'))     ->
      (eq_type c (s1,s2)) && (eq_term c (t,t'))
  | _ -> false

(** Term equivalence *)
and eq_term c (t,t') = eq_whnf c ((whnf t), (whnf t'))

(** Check t1 =wh t2 *)
and eq_whnf c = function
  | (Var x, Var y) -> (x = y)
  | (Id n, Id m) -> (n = m)
  | (Abs (s1,t), Abs (s2,t')) -> 
    let c' = assume_type s1 c in
      (eq_type c (s1,s2)) && (eq_term c' (t,t'))
  | (All (s1,t1) , All (s2,t2)) -> 
    let c' = assume_type s1 c in
      eq_type c (s1,s2) && (eq_term c' (t1,t2)) 
  | (App (s,t), App (s',t'))  -> 
    (eq_whnf c (s,s')) && (eq_whnf c (t,t'))

  | (Abs (s,t),t')   ->  
    let c' = assume_type s c in  (eq_term c' (t, App (t, Id 0)))  
  | (t',Abs (s,t))   ->  
    let c' = assume_type s c in (eq_term c' (t, App (t, Id 0)))  
  | _ -> false


let eq_test () = ()*)
