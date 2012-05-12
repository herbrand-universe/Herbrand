(* ****************************************************************************
 *   Esto deberia abstraer todo lo que use 'constraints'.
 *  Ahora tambien incluye todo lo relacionado con 'level variables'. Si en 
 *  algun momento el manejo de 'level variables' crece, creamos otro archivo
 *  para universos y separamos un poco la parte de 'constraints' de lo otro.
 * ***************************************************************************)
open Term

type rel =
  | LT
  | LE
  | EQ

type lassignment = (Term.name * int) list

(** One level variable *)
module LVar = struct
  type t = string 
  let compare = String.compare
end

(** One constraint *)
type constr =
  | C of rel * Term.universe * Term.universe

module LConstraint = struct
  type t = constr 
  let compare _ _ = 1  (* Completar *)
end

(** Set of level expresions *)
module LVars = Set.Make( LVar )

(** Set of constraints *)
module LConstraints = Set.Make ( LConstraint )


(* ****************************************************************************
 * val termLV : term -> LVars 
 *
 * Is the set of level variables occurring in X.
 *                                               See LV(X) in Harper & Pollack
 * ***************************************************************************)
let rec termLV = function
  | Sort (Type ( Uvar x)) -> LVars.add x (LVars.empty)
  | Pi  (t1,t2) -> LVars.union (termLV t1) (termLV t2)
  | Lam (t1,t2) -> LVars.union (termLV t1) (termLV t2)
  | App (t1,t2) -> LVars.union (termLV t1) (termLV t2)
  | _           -> LVars.empty

(* ****************************************************************************
 * val lastLV : int ref
 *
 * Accumulates the last count value in the fresh level variables sequence
 *
 * ***************************************************************************)
let lastLV = ref 0

(* ****************************************************************************
 * val  : () -> int
 *
 * Gives a new fresh level variable
 *
 * ***************************************************************************)
let freshLV () = incr lastLV; Uvar ("x" ^ string_of_int !lastLV)



(* ****************************************************************************
 * val constrLV : LConstraints -> LVars 
 *
 * Is the set of level variables occurring in constraint set C.
 *                                               See LV(C) in Harper & Pollack
 * ***************************************************************************)

let constrLVaux = function
  | C (_ , Uvar x, Uvar y)  -> LVars.add x (LVars.add y (LVars.empty))
  | C (_ , Uvar x, _     )  -> LVars.add x (LVars.empty)
  | C (_ , _     , Uvar x)  -> LVars.add x (LVars.empty)
  | _                       -> LVars.empty

let constrLV set = 
  let aux e a = LVars.union (constrLVaux e) a
  in LConstraints.fold aux set LVars.empty

(* ****************************************************************************
 * val domLA: lassignment -> LVars 
 *
 * domLA(o) is the set of level variables assigns to.
 *                                               See Dom(o) in Harper & Pollack
 * Nota: ¿No molesta considerar una funcion como una lista?
 * ***************************************************************************)
let rec domLA = function
  | []           -> LVars.empty
  | (lv,n) :: xs -> LVars.add lv (domLA xs)



(* ****************************************************************************
 * val lvalue : lassignment -> lvar -> int
 *
 * Note: Only use 'lvalue' after check if var x exists in the domain of 'la'
 *    otherwise, catch the exception ...
 * ***************************************************************************)
let lvalue la = function
  | Uvar x       -> List.assoc x la (*You must check if x is in the domain *)
  | Uint n       -> n


(* ****************************************************************************
 * val check_inequality : lassignment -> constr -> bool
 *
 * Note: Only use 'check_inequality' after check that all level variables are
 *    in the domain of 'la'  otherwise, catch the exception ...
 * ***************************************************************************)
let check_inequality la = function
  | C (LT,t1,t2) -> (lvalue la t1) <  (lvalue la t2)
  | C (LE,t1,t2) -> (lvalue la t1) <= (lvalue la t2)
  | C (EQ,t1,t2) -> (lvalue la t1) =  (lvalue la t2)


(* ****************************************************************************
 * val check_inequalities : lassignment -> LConstraints -> bool
 *
 * Note: Only use 'check_inequalities' after check that all level variables are
 *    in the domain of 'la'  otherwise, catch the exception ...
 * ***************************************************************************)
let check_inequalities la lconst = 
  LConstraints.for_all (check_inequality la) lconst

(* ****************************************************************************
 * val satisfies : lassignment -> LConstraints -> bool
 *
 * Note: We assume that (&&) is lazy otherwise ... err ...
 * ***************************************************************************)
let satisfies la const =
  (LVars.subset (constrLV const) (domLA la))
  && (check_inequalities la const)

(* ****************************************************************************
 * val cum : LConstraints -> term -> term * LConstraints
 *
 *
 * ***************************************************************************)
let cum c x = match whnf x with
  | (Sort (Type l)) -> let a = freshLV () in
    (Sort (Type a)), LConstraints.add (C(LE, l, a)) c
  | _ -> x, c


(* ****************************************************************************
 * val upArr : LConstraints -> sort * sort -> sort * LConstraints
 *
 *
 * ***************************************************************************)
let upArr c = function
  | _, Prop -> Prop, c
  | Prop, Type l -> let a = freshLV () in
    Type a, LConstraints.add (C(LE, l, a)) c
  | Type l, Type m -> let a = freshLV () in
    Type a, LConstraints.add (C(LE, l, a)) (LConstraints.add (C(LE, m, a)) c)



(* ****************************************************************************
 * val downArr : term -> term -> LConstraints
 *
 * Return the weakest constraint set or raise an exception (ConvFail)
 * ***************************************************************************)
exception ConvFail 
let rec downArr t1 t2 = match whnf t1,whnf t2 with
  | Sort (Type a), Sort (Type b)   -> LConstraints.add (C (EQ,a,b)) LConstraints.empty
  | Pi    (x1,x2), Pi (y1,y2)      -> LConstraints.union (downArr x1 y1) (downArr x2 y2)
  | Lam   (x1,x2), Lam (y1,y2)     -> LConstraints.union (downArr x1 y1) (downArr x2 y2)
  | App   (x1,x2), App (y1,y2)     -> LConstraints.union (downArr x1 y1) (downArr x2 y2)
  | Var x, Var y when (x = y)      -> LConstraints.empty
  | Id  x , Id y when (x = y)      -> LConstraints.empty
  | _                              -> raise ConvFail



open Format

(* Deriving 'show' :P*)
let pp_lvar fmt = function
  | Uvar x   -> fprintf fmt "%s" x
  | Uint n   -> fprintf fmt "%d" n

let pp_constr fmt = function 
  | C (LT, t1 ,t2) -> fprintf fmt "[%a <  %a]" pp_lvar t1 pp_lvar t2
  | C (LE, t1 ,t2) -> fprintf fmt "[%a <= %a]" pp_lvar t1 pp_lvar t2
  | C (EQ, t1 ,t2) -> fprintf fmt "[%a =  %a]" pp_lvar t1 pp_lvar t2

let pp_lconstr fmt lconstr =
  let pp_aux e = pp_constr fmt e
  in
    fprintf fmt "{";
    LConstraints.iter pp_aux lconstr;
    fprintf fmt "}"



