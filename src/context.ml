open Term
type context = {
  mutable global : (Term.name * (Term.term * Term.term )) list;
  mutable local  : Term.term list;
}


let empty () = {global = []; local = []}

let addGlobal c n t ty = c.global <- (n, (t, ty)) :: c.global; c

let addLocal c t = { c with local = (t :: c.local)}

let inLocal c i = i <= (List.length c.local)

let inGlobal c n = List.mem_assoc n c.global

let getType c n =   let _,ty=  (List.assoc n c.global) in  ty 
let getDef  c n =   let t,_  =  (List.assoc n c.global) in  t

let getGlobal c n = List.assoc n c.global

let getLocal  c i = List.nth c.local (i-1)


(* ****************************************************************************
 * val whnf : context -> term -> term
 *
 * Nota: \x -> x = \ 1  (Los indices empiezan en 1)
 * ***************************************************************************)
let rec whnf c = function
  | App (t1, t2) -> 
    (match whnf c t1 with
      | Lam (_,t)   -> whnf c (Term.dBsubs 1 t2 t) 
      | t           -> App (t,t2))

  | R t          ->
    (match whnf c t with
      | Pair (_,_,t2)   -> whnf c t2
      | t               -> R t)

  | L t          ->
    (match whnf c t with
      | Pair (_,t1,_)   -> whnf c t1
      | t               -> L t)

  | Var x        -> whnf c (getDef c x)
  | t            -> t

let whnf_is_kind c t = match whnf c t with
  | Sort t1        -> true
  | _              -> false

let get_whnf_kind c t = match whnf c t with
  | Sort t1         -> t1

let get_whnf_pi c t = match whnf c t with
  | Pi (a,b) -> a,b

let get_whnf_sigma c t = match whnf c t with
  | Sigma (a,b) -> a,b
