open Array
open Constraints
open List
open Term


let rec index_of e i = function
  | [] -> None
  | x :: xs -> if x = e then Some i else index_of e (i+1) xs

let cmp = function
  | C (c, _, _) -> c

let src = function
  | C (_, s, _) -> s

let dst = function
  | C(_, _, d) -> d

let pos e xs = match index_of e 1 xs with
  | None -> 0 (* this should not happen *)
  | Some i -> i

let init_graph c = let nelem = 1 + LConstraints.cardinal c
                   in make_matrix nelem nelem 0

let set_node ls gr = function
                  | C(LE, Uvar u, Uvar v) -> gr.(pos u ls).(pos v ls) <- 0
                  | C(LE, Uint i, Uvar v) -> gr.(0).(pos v ls) <- i
                  | C(LE, Uvar u, Uint j) -> gr.(pos u ls).(0) <- (-j)
                  | C(LT, Uvar u, Uvar v) -> gr.(pos u ls).(pos v ls) <- 1
                  | C(LT, Uint i, Uvar v) -> gr.(0).(pos v ls) <- (i + 1)
                  | C(LT, Uvar u, Uint j) -> gr.(pos u ls).(0) <- (1 - j)

let add_elem xs = function
  | Uint _ -> xs
  | Uvar e -> (match index_of e 0 xs with
    | None -> e :: xs
    | Some _ -> xs)

let make_list c = let f c xs = add_elem (add_elem xs (src c)) (dst c) in
                  LConstraints.fold f c []

(* ****************************************************************************
 * val normalize : LConstraints -> LConstraints
 *
 * replaces each equality for a pair of inequalities
 *
 * ***************************************************************************)
let normalize c = let f c cs = (match c with
                    | C(EQ, x, y) -> LConstraints.add (C(LE, x, y)) (LConstraints.add (C(LE, y, x)) cs)
                    | c -> LConstraints.add c cs) in
                  LConstraints.fold f c LConstraints.empty

(* ****************************************************************************
 * val check_and_remove_arith : LConstraints -> LConstraints option
 *
 * checks and removes full arithmetic constraints (Uint i compared to Uint j)
 *
 * ***************************************************************************)
let check_and_remove_arith c = let f c cs = (match cs with
                                 | None -> None
                                 | Some cs -> (match c with
                                   | C(EQ, Uint i, Uint j) -> if i = j then Some cs else None
                                   | C(LT, Uint i, Uint j) -> if i < j then Some cs else None
                                   | C(LE, Uint i, Uint j) -> if i <= j then Some cs else None
                                   | c -> Some (LConstraints.add c cs))) in
                               LConstraints.fold f c (Some LConstraints.empty)

(* ****************************************************************************
 * val make_graph : LConstraints -> int array array
 *
 * returns the corresponding graph from a set of constraints
 *
 * ***************************************************************************)
let make_graph c = let c = normalize c in
                   let gr = init_graph c in
                   let ls = make_list c in
                   LConstraints.iter (set_node ls gr) c

(* ****************************************************************************
 * val has_positive_cycle : int array array -> bool
 *
 * returns whether the graph has a positive cycle
 *
 * ***************************************************************************)
let has_positive_cycle gr = true


(* ****************************************************************************
 * val satisfiable : LConstraints -> bool
 *
 * returns whether the set of contraints is satisfiable or not
 *
 * ***************************************************************************)
let satisfiable c = match check_and_remove_arith c with
                    | None -> false
                    | Some c -> has_positive_cycle (make_graph c)
