open Term
(* ****************************************************************************
 * Context :
 *      decl = [a:A][b:B] ... 
 *      defs = [a=s:A][b=t:B] ...
 *      
 *      local = [A,B,C,D] ...   (DeBruijn index)
 * ***************************************************************************)
type context = {
  mutable decls   : (Term.name * Term.term) list;
  mutable defs: (Term.name * (Term.term * Term.term )) list;
  mutable local  : Term.term list;
}


let empty () = {defs = []; decls = []; local = []}

let addDecl c n ty = { c with decls = (n,ty) :: (c.decls)}
let addDef  c n t ty = { c with defs = (n,(t,ty)) :: c.defs}

let addLocal c t = { c with local = (t :: c.local)}

let inLocal c i = i <= (List.length c.local)

let isDecl c n = (List.mem_assoc n c.defs) || (List.mem_assoc n c.decls)
let isDef c n  = List.mem_assoc n c.defs


let getType c n = match  List.mem_assoc n c.decls with
  | true  -> let ty=  (List.assoc n c.decls) in  ty 
  | false -> let _,ty=  (List.assoc n c.defs) in  ty

let getDef  c n =   let t,_  =  (List.assoc n c.defs) in  t

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

  | Snd t          ->
    (match whnf c t with
      | Pair (_,_,t2)   -> whnf c t2
      | t               -> Snd t)

  | Fst t          ->
    (match whnf c t with
      | Pair (_,t1,_)   -> whnf c t1
      | t               -> Fst t)

  | Var x    when (isDef c x)   -> whnf c (getDef c x)
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

