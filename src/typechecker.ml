open Term
module T = Term
module C = Context


(* Instead of using the option type, here we use exception ... *)
exception Error


(******************************************************************************
 * val downArr c t1 t2 : context -> term -> term -> bool
 *
 *   This is the well known CONV rule. 
 *
 * Right now, is a conversion up to beta - delta reduction.
 *
 *   We should prove that under the assumption that the terms are SN its
 * equivanlent reduce to weak head normal form instead of normal form.
 *
 *   I suppose that is enough to known that the relation beta-delta is confluent
 * and the theory have the SN property.
 ******************************************************************************)
let rec downArr c t1 t2 = match C.whnf c t1,C.whnf c t2 with
  | Sort (Type a), Sort (Type b)   -> a = b
  | Pi    (x1,x2), Pi (y1,y2)      -> (downArr c x1 y1) && (downArr c x2 y2)
  | Sigma (x1,x2), Sigma (y1,y2)   -> (downArr c x1 y1) && (downArr c x2 y2)
  | Lam   (x1,x2), Lam (y1,y2)     -> (downArr c x1 y1) && (downArr c x2 y2)
  | App   (x1,x2), App (y1,y2)     -> (downArr c x1 y1) && (downArr c x2 y2)
  | Fst x        , Fst y           -> downArr c x y
  | Snd x        , Snd y           -> downArr c x y
  | Pair (s,x1,x2), Pair (t,y1,y2) -> (downArr c s t) && (downArr c x1 y1) && (downArr c x2 y2)
  | Var x, Var y when (x = y)      -> true
  | Id  x , Id y when (x = y)      -> true
  | Sort (Prop), Sort (Prop)       -> true
  | _                              -> false



(******************************************************************************
 * val leq c n m : context -> term -> term -> bool
 *
 *  This is <= relation over the universe hierarchy.
 ******************************************************************************)
let rec leq c n m = match C.whnf c n, C.whnf c m with
  | s  ,   t  when (downArr c s t) -> true
  | Sort Prop, Sort (Type a)       -> true
  | Sort (Type a), Sort (Type b)   -> a < b
  | Pi (a1,a2), Pi (b1,b2)         -> (downArr c a1 b1) && (leq c a2 b2)
  | Sigma (a1,a2), Sigma (b1,b2)   -> (leq c a1 b1) && (leq c a2 b2)
  | _                              -> false


(******************************************************************************
 * val typeof : context -> term -> term -> bool
 *
 *  
 ******************************************************************************)
let rec typeof c = function
  | Sort Prop                                      -> Sort (Type 0)
  | Sort (Type a)                                  -> Sort (Type (a + 1))
  | Id n           when (C.inLocal c n)            -> C.getLocal c n
  | Var x          when (C.inGlobal c x)           -> C.getType c x
  | App (m,n)      when (test pAppRule c m n)      -> cAppRule c m n
  | Pi  (a,b)      when (test pGenRule c a b)      -> cGenRule c a b
  | Lam (a,m)      when (test pAbsRule c a m)      -> cAbsRule c a m
  | Sigma (a,m)    when (test pSigmaRule c a m)    -> cSigmaRule c a m
  | Pair (a,n, m)  when (test3 pPairRule c a n m)  -> cPairRule c a n m
  | Fst m          when (test2 pProjRule c m)      -> cFstRule c m
  | Snd m          when (test2 pProjRule c m)      -> cSndRule c m
  | _                                              -> raise Error

and test f a b c    = try f a b c with _ -> false
and test2 f a b     = try f a b with _ -> false
and test3 f a b c d = try f a b c d with _ -> false

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
 *      C = Sigma (A,B)     G |- C : T      T ->> k
 *      G |- M1 : T1                    T1 <= A
 *      G |- M2 : T2                    T2 <= [M/1]B
 *  ----------------------------------------------------------          (A-Pair)
 *      G |- Pair C (M1,M2) : C
 * 
 ******************************************************************************)
and pPairRule g c m1 m2 = match c with
  | Sigma (a,b) -> (validType g c) && (leq g (typeof g m1) a) 
                   && (leq g (typeof g m2) (dBsubs 1 m1 b))
  | _ -> false

and cPairRule g c _ _ = c

(******************************************************************************
 *
 *    G |- M : T          T ->> Sigma (A,B)
 *  ----------------------------------------------------------           (A-Fst)
 *              G |-  fst  M  :  A
 ******************************************************************************)
and pProjRule g m = 
   let t = typeof g m in
   match C.whnf g t with
     | Sigma (_,_)   -> true
     | _             -> false

and cFstRule g m =
   let t = typeof g m in
   let a,_ = C.get_whnf_sigma g t in
   a

(******************************************************************************
 *
 *    G |- M : T          T ->> Sigma (A,B)
 *  ----------------------------------------------------------          (A-Snd)
 *              G |-  snd  M  :  [Left M/1] B
 ******************************************************************************)
and cSndRule g m =
   let t = typeof g m in
   let _,b = C.get_whnf_sigma g t in
   (dBsubs 1 (Fst m) b)

