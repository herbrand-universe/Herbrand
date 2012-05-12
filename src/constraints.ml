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



