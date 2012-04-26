open Term
(** There are three kind of elements in the context:
  * a) Local variables for deBrujin index
  * b) Global variables for terms
  * c) Global varaiabls for types  
  *
  * Now, the last two case are static, because you 
  * only add this bindings in the code and never change *) 



let (>>=) a f = match a with
  | None  -> None
  | Some v -> f v


let (>>) a b = match a, b with
  | None, _ -> b
  | _   , c     -> c


(*
type context_elem  =
  | CId of Term.ty
  | TermBind of Term.term * Term.ty
  | TyBind of Term.ty * Term.kind


type context = {
  mutable binds : context_elem list
}


(** Now the initial context is empty but we need
 * some initial kinds and types. *)
(** TODO: Check well-formed kins rules ...  *)
let init_context () = {binds = (TyBind ((TVar "X"), Star)) ::  [] }

let assume_type ty c = 
  {binds = (CId ty) :: c.binds}

exception Context_Fail


let get_type_n c n = 
  match List.nth c.binds n with
    | CId ty -> ty
    | _     -> raise Context_Fail

(** TODO: Find better symbols for infix operators *)
let (<:>) t ty = TermBind (t,ty)

(** TODO: Find better symbols for infix operators *)
let (<::>) ty k = TyBind (ty,k)

(** TODO: Find better symbols for infix operators *)
let (@@) c bind  = 
  c.binds <- bind :: c.binds ; c

let add_term_bind c t ty =
  c @@ (t <:> ty)


let add_type_bind c ty k =
  c @@ (ty <::> k)

let is_term_bind t = function
  | TermBind (t',_) -> (t = t')
  | _ -> false 

let is_type_bind t = function
  | TyBind (t',_) -> (t = t')
  | _ -> false 

let exists_term_bind_of t c  = 
  try ignore(List.find (is_term_bind t) c.binds); true
  with Not_found -> false


let exists_type_bind_of ty c = 
  try ignore(List.find (is_type_bind ty) c.binds); true
  with Not_found -> false


let get_term_bind_of t c =
  match (List.find (is_term_bind t) c.binds ) with
    | TermBind (_,t1) -> t1
    | _ ->     raise Context_Fail
 
let get_type_bind_of t c =
  match (List.find (is_type_bind t) c.binds) with
    | TyBind (_,k) -> k
    | _            -> raise Context_Fail
*)
