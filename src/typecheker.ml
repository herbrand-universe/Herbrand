open Context
open Term
open Eq
exception TypeError

(* LV(X) *)
(* val levels_vars_in_term : term -> name list *)
let rec levels_vars_in_term  = function
   | Sort (Type (Uvar x)) -> [x]
   | Pi (_,t1,t2 ) -> (levels_vars_in_term t1) @ (levels_vars_in_term t2)
   | Lam (_,t1,t2 ) -> (levels_vars_in_term t1) @ (levels_vars_in_term t2)
   | App (t1,t2 ) -> (levels_vars_in_term t1) @ (levels_vars_in_term t2)
   | _ -> []


(* LV(C) *)
(* val levels_vars_in_const : constraints -> name list *)
let rec levels_vars_in_const = function
  | [] -> []
  | (LE (n1,n2)) :: xs -> n1 :: (n2 :: (levels_vars_in_const xs))
  | (GE (n1,n2)) :: xs -> n1 :: (n2 :: (levels_vars_in_const xs))
  | (GT (n1,n2)) :: xs -> n1 :: (n2 :: (levels_vars_in_const xs))
  | (LT (n1,n2)) :: xs -> n1 :: (n2 :: (levels_vars_in_const xs))
  | (EQ (n1,n2)) :: xs -> n1 :: (n2 :: (levels_vars_in_const xs))


(* val level_assignment = [ name, int ] *)

let rec dom_level_assignment = function
  | [] -> []
  | (name,level) :: xs -> name :: (dom_level_assignment xs)

(************************************************************************)
(* Check inequalities *)
(************************************************************************)

let rec check_true_inequalities_in_la la  = function
  | []  -> true
  | (LE (n1,n2)) :: xs  -> 
    ((lvalue la n1) <= (lvalue la n2)) && (check_true_inequalities_in_la la xs)
  | (GE (n1,n2)) :: xs  -> 
    ((lvalue la n1) >= (lvalue la n2)) && (check_true_inequalities_in_la la xs)
  | (LT (n1,n2)) :: xs  -> 
    ((lvalue la n1) < (lvalue la n2)) && (check_true_inequalities_in_la la xs)
  | (GT (n1,n2)) :: xs  -> 
    ((lvalue la n1) > (lvalue la n2)) && (check_true_inequalities_in_la la xs)
  | (EQ (n1,n2)) :: xs  -> 
    ((lvalue la n1) = (lvalue la n2)) && (check_true_inequalities_in_la la xs)

and lvalue la n =
   try List.assoc n la 
   with _ -> -1 (*We need to check the domain before call check_true .. *) 


(************************************************************************)
(* Test:a *)

let chk_test1 = check_true_inequalities_in_la [("n",3);("a",4)] [LE ("n","a")]
let chk_test2 = check_true_inequalities_in_la [("n",3);("a",3)] [LE ("n","a");
GE ("n","a")]
let chk_test3 = check_true_inequalities_in_la [("n",3);("a",4)] [GE ("n","a")]

let _ = assert(chk_test1 && chk_test2 && (not chk_test3))

(************************************************************************)
(************************************************************************)



(************************************************************************)
(* Set include  *)
(************************************************************************)
let set_include xs ys =
  let x_in_ys x = List.exists (fun y -> x = y) ys in 
  List.for_all (fun x -> x_in_ys x) xs


(************************************************************************)
(* Test:a *)
let st_test1  = set_include ["a"; "b"] ["aa"; "a"; "b"; "c"]
let st_test2 = set_include ["a"; "b"] ["a"; "b"]
let st_test3 = not (set_include ["a"; "b"] ["aa"; "b"; "c"])

let _ = assert (st_test1 && st_test2 && st_test3 )

(************************************************************************)
(************************************************************************)



(************************************************************************)
(* Satisfies inequalities *)
(************************************************************************)
(* la |= const  <->  LV(C) c Dom (la) (set inclusion) *)
let satisfies la const =
  (set_include (levels_vars_in_const const) (dom_level_assignment la))
  && (check_true_inequalities_in_la la const)




(************************************************************************)
(* Test:a *)
let sat_test1  = not (satisfies [("a",1)] [LE ("b", "a") ])
let sat_test2 = satisfies [("a",1); ("b",1)] [LE ("b", "a") ]
let sat_test3 = not (satisfies [("a",1); ("b",2)] [LE ("b", "a") ])

let _ = assert (sat_test1 && sat_test2 && sat_test3 )



(************************************************************************)
(************************************************************************)

let fresh_var () = "a"

let cum (t,c) = match whnf t with 
  | Sort (Type (Uvar y)) -> let a = fresh_var () in (Sort (Type (Uvar a )), c @ [GE (a,y)])
  | _                    -> (t,c)


let flecha k1 k2 c = match k1,k2 with
  | _, Prop             -> (Prop,c)
  | Prop, Type (Uvar y) -> 
    let a = fresh_var () in 
        (Type (Uvar a), c @ [ GE(a,y)])
  | Type (Uvar y), Type (Uvar u) ->
    let a = fresh_var () in 
        (Type (Uvar a),c @ [GE (a,y);GE (a,u)])






(*
  (* Well-formed kinds: 
 *
 *                 ----------                                        (WFA-STAR)
 *                   C |- *                                         
 *
 *
 *                 C |- T :: *      C, x : T |- K
 *                 -------------------------------                     (WFA-PI)
 *                     C |- \Pi x : T. K
 *
 *
 * ****************************************************************************)
(*
let rec wf_kind c k = match k with
  | Star             -> true
  | KProd (x,ty,k)   -> (kindof c ty =  Star) && (wf_kind (c @ [TermBind x ty]) k)
*)

 (* Kinding:
 *
 *               X :: K \in C
 *               -------------                                         (KA-Var)
 *               C |- X :: K
 *
 *
 *            C |- T1 :: *      C ,x : T1 |- T2 :: *
 *            --------------------------------------                    (KA-Pi)
 *                   C |- \Pi x : T1.T2 :: *
 *
 *
 *        C |- S :: \Pi x:T1 . K     C |- t : T2   C |- T1 = T2
 *       -------------------------------------------------------       (KA-App)
 *                      C |- S t ::  [x -> t] K
 *                  
 *
 *
 * ****************************************************************************)

let rec kind_of c  = function

(******************************************************************************
 *               X :: K \in C
 *               -------------                                          (KA-Var)
 *               C |- X :: K                                                  
 ******************************************************************************)
  | TVar x when (exists_type_bind_of (TVar x) c) ->  
                  get_type_bind_of (TVar x) c

(******************************************************************************
 *
 *            C |- T1 :: *      C ,x : T1 |- T2 :: *
 *            --------------------------------------                    (KA-Pi)
 *                   C |- \Pi x : T1.T2 :: *
 *
 ******************************************************************************)



  | TProd (t1,t2) -> 
    let c' = assume_type t1 c in
      if (eq_kind c (kind_of c t1, Star))  && (eq_kind c (kind_of c' t2,Star))
      then Star
      else raise TypeError
  | TApp (Prf, t) when (eq_type c ((type_of c t), Prop)) -> Star

  | TApp (s,t) ->
    (begin
    match kind_of c s with
      | KProd (t1,k)  when (eq_type c ((type_of c t),t1)) -> subs_kind 0 t k
      | _             -> raise TypeError
    end)
(******************************************************************************
 *
 *        C |- S :: \Pi x:T1 . K     C |- t : T2   C |- T1 = T2
 *       -------------------------------------------------------       (KA-App)
 *                      C |- S t ::  [x -> t] K
 *                  
 ******************************************************************************)
  | Prop                 -> Star
  | _ -> raise TypeError
 
(* Typing
 *
 *             x : T \in C
 *            -------------                                            (TA-VAR)
 *              C |- x : T
 *
 *
 *             C |- S :: *      C, x : S |- t : T
 *             --------------------------------------                  (TA-Abs)
 *             C |- \lambda x : S . t : \Pi x : S . T
 *
 *
 *             C |- t1 : \Pi x : S1.T    C |- t2 : T2    C |- S1 = S2  
 *             ------------------------------------------------------  (TA-App)
 *                   C |- t1 t2 : [x -> t2] T
 *
 * ****************************************************************************

*)

and  type_of c = function 
(******************************************************************************
 *
 *             x : T \in C
 *            -------------                                            (TA-VAR)
 *              C |- x : T
 *
 ******************************************************************************)
  | Var x when (exists_term_bind_of (Var x) c)-> get_term_bind_of (Var x) c
  | Id  n                          -> get_type_n c n
(******************************************************************************
 *
 *             C |- S :: *      C, x : S |- t : T
 *             --------------------------------------                  (TA-Abs)
 *             C |- \lambda x : S . t : \Pi x : S . T
 *
 ******************************************************************************)
  | Abs (s,t) ->
    let c' = assume_type s c in
    if (eq_kind c ((kind_of c s),Star)) then 
      TProd (s,(type_of c' t))
    else
      raise TypeError
(******************************************************************************
 *
 *             C |- t1 : \Pi x : S1.T    C |- t2 : T2    C |- S1 = S2  
 *             ------------------------------------------------------  (TA-App)
 *                   C |- t1 t2 : [x -> t2] T
 *
 ******************************************************************************)
  | App (t1,t2)   -> 
    begin
    match type_of c t1 with
      | TProd (s1,t)  -> 
        if (eq_type c (s1, (type_of c t2)))
        then subs_type 0 t2 t 
        else raise TypeError 
      | _             -> raise TypeError

    end
  | All (ty,t) ->
    let c' = assume_type ty c in
    if (eq_kind c ((kind_of c ty),Star)) then
      if (eq_type c' ((type_of c' t), Prop)) then
        Prop
      else
        raise TypeError
    else
      raise TypeError

  | _ -> raise TypeError
*)
