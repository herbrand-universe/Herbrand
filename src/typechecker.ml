open Term
open Constraints
module T = Term
module C = Context
(*module Univ = Constraints*)
module S = Satisfiable



let zero = Uint 0
(* This part should be in constraints.ml ... *)
let typeofSorts c = function
  | Prop   -> let a = freshLV () in (Sort (Type a)), (zero <=. a)
  | Type j -> let a = freshLV () in (Sort (Type a)), (j <. a) 



(* Instead of using the option type, here we use exception ... *)
exception Error

(* ****************************************************************************
 * val cum : LConstraints -> term -> term * LConstraints
 *
 *
 * ***************************************************************************)
let cum c x = match whnf x with
  | (Sort (Type l)) -> 
    let a = Constraints.freshLV () in Sort (Type a), Constraints.union (l <=. a) c
  | _ -> x, c


(* ****************************************************************************
 * val upArr : LConstraints -> sort * sort -> sort * LConstraints
 *
 *
 * ***************************************************************************)
let upArr c = function
  | _, Prop -> Prop, c
  | Prop, Type l -> let a = Constraints.freshLV () in
    Type a, Constraints.union (l <=. a) c
  | Type l, Type m -> let a = Constraints.freshLV () in
    Type a, Constraints.union (l <=. a) (Constraints.union (m <=. a) c)


(* ****************************************************************************
 * val downArr : term -> term -> LConstraints
 *
 * Return the weakest constraint set or raise an exception (ConvFail)
 * ***************************************************************************)
exception ConvFail 
let rec downArr t1 t2 = match whnf t1,whnf t2 with
  | Sort (Type a), Sort (Type b)   -> a =. b
  | Pi    (x1,x2), Pi (y1,y2)      -> Constraints.union (downArr x1 y1) (downArr x2 y2)
  | Lam   (x1,x2), Lam (y1,y2)     -> Constraints.union (downArr x1 y1) (downArr x2 y2)
  | App   (x1,x2), App (y1,y2)     -> Constraints.union (downArr x1 y1) (downArr x2 y2)
  | Var x, Var y when (x = y)      -> Constraints.empty
  | Id  x , Id y when (x = y)      -> Constraints.empty
  | Sort (Prop), Sort (Prop)       -> Constraints.empty
  | _                              -> raise ConvFail


(******************************************************************************
 * val typeof : context -> term -> (term * LConstraints)
 *
 * Warning: All preconditions can raise an exception, an exception must be
 *         understand as 'false'. So we test preconditions with the function
 *        'test'.
 ******************************************************************************)
let rec typeof c = function
  | Sort a                                  -> typeofSorts c a
  | Id  n       when (C.inLocal  c n)       -> cum empty (C.getLocal  c n) 
  | Var x       when (C.inGlobal c x)       -> cum empty (C.getGlobal c x) 
  | App (m,n)   when (test pAppRule c m n)  -> cAppRule c m n
  | Pi  (a,b)   when (test pGenRule c a b)  -> cGenRule c a b
  | Lam (a,m)   when (test pAbsRule c a m)  -> cAbsRule c a m
  | _                                       -> raise Error

and test f a b c = try f a b c with _ -> false

(******************************************************************************
 * val validType : context -> term -> bool                       (or EXCEPTION!)
 *
 *   G |- A => X , C    /\      X ->> k        
 *
 * Note: We need to ensure that a type is valid, so is not enough to check
 *      that exists some A such (x : A), we need to check at the same time
 *      that A has a 'kind' as type. 
 ******************************************************************************)
and validType c t = 
  let x, _ = typeof c t in Term.whnf_is_kind x

(******************************************************************************
 * val validTypeS : context -> term -> bool                      (or EXCEPTION!)
 *
 *   G |- A => X , C    /\      X ->> k        /\  C satisfiable (or consistent)   
 *
 * Note: We need to ensure that a type is valid, so is not enough to check
 *      that exists some A such (x : A), we need to check at the same time
 *      that A has a 'kind' as type. Furthermore we check that the set of
 *      constraints are satisfiable (This is a safe version of validType)
 ******************************************************************************)
and validTypeS c a = 
  let x, constr = typeof c a 
  in (Term.whnf_is_kind x) && (S.satisfiable constr)


(******************************************************************************
 *  
 *        G |- A => X, C   /\   X ->> k1    /\  C safisfiable  
 *
 *     G, A |- B => Y, D   /\   Y ->> k2
 *  ----------------------------------------------------------           (A-GEN)
 *        G |-  Pi A B  =>  k1 ´upArr_(C u D)´ k2
 *
 ******************************************************************************)
and pGenRule c t1 t2 = validTypeS c t1 && validType (C.addLocal c t1) t2
and cGenRule c a b =
    let x,d = typeof c a in
    let y,e = typeof (C.addLocal c a) b in
    let k1  = get_whnf_kind x in
    let k2  = get_whnf_kind y in
    let g,h = upArr (union d e) (k1,k2) in
    Sort g,h


(******************************************************************************
 *  
 *         G |- A => X, C   /\   X ->> k1    /\  C safisfiable  
 *
 *      G, A |- M => Y, D   
 *  ----------------------------------------------------------           (A-ABS)
 *         G |- Lam A M  =>  Pi A Y,  C u D
 *
 ******************************************************************************)
and pAbsRule g a m =  validTypeS g a && hasType   (C.addLocal g a) m
and cAbsRule g a m =
    let _, c = typeof g a in
    let y, d = typeof (C.addLocal g a) m in
    Pi (a,y), (union c d)


and hasType g t = try ignore(typeof g t); true with _ -> false

(******************************************************************************
 *  
 *         G |- M => X, C   /\   X ->> Pi X1 X2  
 *
 *         G |- N => Y, D   /\   (X1 ´downArr´ Y) (E)
 *  ----------------------------------------------------------           (A-APP)
 *         G |- App M N  =>  CUM ( [N / 1] X2 , C u D u E)
 *
 ******************************************************************************)
and pAppRule g m n = 
  let x, c = typeof g m in
  let y, d = typeof g n in
  match whnf x with
    | Pi (x1,_)  -> ignore (downArr x1 y); true
    | _          -> false

and cAppRule g m n = 
  let x , c  = typeof g m in
  let x1, x2 = Term.get_whnf_pi x in
  let y , d = typeof g n in
  let e = downArr x1 y in
    cum (union c (union d e)) (dBsubs 1 n x2)

