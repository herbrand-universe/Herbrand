open Term
module T = Term
module C = Context


(* Instead of using the option type, here we use exception ... *)
exception Error


(******************************************************************************
 *
 ******************************************************************************)

let rec downArr c t1 t2 = match C.whnf c t1,C.whnf c t2 with
  | Sort (Type a), Sort (Type b)   -> a = b
  | Pi    (x1,x2), Pi (y1,y2)      -> (downArr c x1 y1) && (downArr c x2 y2)
  | Sigma (x1,x2), Sigma (y1,y2)   -> (downArr c x1 y1) && (downArr c x2 y2)
  | Lam   (x1,x2), Lam (y1,y2)     -> (downArr c x1 y1) && (downArr c x2 y2)
  | App   (x1,x2), App (y1,y2)     -> (downArr c x1 y1) && (downArr c x2 y2)
  | L x          , L y             -> downArr c x y
  | R x          , R y             -> downArr c x y
  | Pair (s,x1,x2), Pair (t,y1,y2) -> (downArr c s t) && (downArr c x1 y1) && (downArr c x2 y2)
  | Var x, Var y when (x = y)      -> true
  | Id  x , Id y when (x = y)      -> true
  | Sort (Prop), Sort (Prop)       -> true
  | _                              -> false



(******************************************************************************
 *
 ******************************************************************************)
let rec leq c n m = match C.whnf c n, C.whnf c m with
  | s  ,   t  when (downArr c s t) -> true
  | Sort Prop, Sort (Type a)       -> true
  | Sort (Type a), Sort (Type b)   -> a < b
  | Pi (a1,a2), Pi (b1,b2)         -> (downArr c a1 b1) && (leq c a2 b2)
  | Sigma (a1,a2), Sigma (b1,b2)   -> (leq c a1 b1) && (leq c a2 b2)
  | _                              -> false


(******************************************************************************
 *
 ******************************************************************************)
let rec typeof c = function
  | Sort Prop      -> Sort (Type 0)
  | Sort (Type a)  -> Sort (Type (a + 1))
  | Id n        when (C.inLocal c n)   -> C.getLocal c n
  | Var x       when (C.inGlobal c x)       -> C.getType c x
  | App (m,n)      when (test pAppRule c m n)   -> cAppRule c m n
  | Pi  (a,b)      when (test pGenRule c a b)   -> cGenRule c a b
  | Lam (a,m)      when (test pAbsRule c a m)   -> cAbsRule c a m
  | Sigma (a,m)    when (test pSigmaRule c a m)   -> cSigmaRule c a m
  | Pair (a,n, m)  when (test pPairRule c a m)  -> cPairRule c a m
  | L m            when (test2 pProjRule c m)  -> cLeftRule c m
  | R m            when (test2 pProjRule c m)  -> cRightRule c m
  
  | _                                       -> raise Error

and test f a b c = try f a b c with _ -> false
and test2 f a b = try f a b with _ -> false

(******************************************************************************
 * val validType : context -> term -> bool                       (or EXCEPTION!)
 *
 *   G |- A => X    /\      X ->> k        
 *
 * Note: We need to ensure that a type is valid, so is not enough to check
 *      that exists some A such (x : A), we need to check at the same time
 *      that A has a 'kind' as type. 
 ******************************************************************************)
and validType c t = 
  let x = typeof c t in C.whnf_is_kind c x


(******************************************************************************
 *  
 *         G |- A => X  /\   X ->> k1 
 *
 *      G, A |- M => Y   
 *  ----------------------------------------------------------           (A-ABS)
 *         G |- Lam A M  =>  Pi A Y
 *
 ******************************************************************************)
and pAbsRule g a m =  validType g a && hasType   (C.addLocal g a) m
and cAbsRule g a m =
    let y = typeof (C.addLocal g a) m in
    Pi (a,y)


and hasType g t = try ignore(typeof g t); true with _ -> false

(******************************************************************************
 *  
 *         G |- M => X   /\   X ->> Pi X1 X2  
 *
 *         G |- N => Y   /\  Y <= X1 
 *  ----------------------------------------------------------           (A-APP)
 *         G |- App M N  =>  [N / 1] X2
 *
 ******************************************************************************)
and pAppRule g m n = 
  let x = typeof g m in
  let y = typeof g n in
  match C.whnf g x with
    | Pi (x1,_)  -> leq g y x1 
    | _          -> false

and cAppRule g m n = 
  let x  = typeof g m in
  let x1, x2 = C.get_whnf_pi g x in
    (dBsubs 1 n x2)

(******************************************************************************
 *  
 *        G |- A => X   /\   X ->> k1    
 *
 *     G, A |- B => Y   /\   Y ->> k2
 *  ----------------------------------------------------------           (A-GEN)
 *        G |-  Pi A B  =>  max(k1, k2)
 *
 ******************************************************************************)
and pGenRule c t1 t2 = validType c t1 && validType (C.addLocal c t1) t2
and cGenRule c a b =
    let x = typeof c a in
    let y = typeof (C.addLocal c a) b in
    let k1  = C.get_whnf_kind c x in
    let k2  = C.get_whnf_kind (C.addLocal c a) y in
    if (k2 = Prop) then (Sort Prop) else
    Sort (max (k1,k2))

and max = function
  | Prop, t  -> t
  | t , Prop -> t
  | Type a, Type b -> if a > b then (Type a) else (Type b)


(******************************************************************************
 *  
 *        G |- A => X   /\   X ->> k1    
 *
 *     G, A |- B => Y   /\   Y ->> k2
 *  ----------------------------------------------------------           (A-GEN)
 *        G |-  Sigma A B  =>  max(k1, k2, Type0)
 *
 ******************************************************************************)
and pSigmaRule c t1 t2 = validType c t1 && validType (C.addLocal c t1) t2
and cSigmaRule c a b =
    let x = typeof c a in
    let y = typeof (C.addLocal c a) b in
    let k1  = C.get_whnf_kind c x in
    let k2  = C.get_whnf_kind (C.addLocal c a) y in
    Sort (max(max (k1,k2),Type 0))


(******************************************************************************
 *
 ******************************************************************************)
and pPairRule g c t1 = true 
and cPairRule g c t1  = Sort Prop

(******************************************************************************
 *
 ******************************************************************************)
and pProjRule g m = 
   let t = typeof g m in
   match C.whnf g t with
     | Sigma (_,_)   -> true
     | _             -> false

and cLeftRule g m =
   let t = typeof g m in
   let a,_ = C.get_whnf_sigma g t in
   a

and cRightRule g m =
   let t = typeof g m in
   let _,b = C.get_whnf_sigma g t in
   (dBsubs 1 (L m) b)

