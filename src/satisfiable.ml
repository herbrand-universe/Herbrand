open Array
open Constraints
open List
open Term


let rec index_of e i = function
  | [] -> None
  | x :: xs -> if x = e then Some i else index_of e (i+1) xs

let pos e xs = match index_of e 0 xs with
  | None -> 0 (* this should not happen *)
  | Some i -> i

let add_elem xs = function
  | Uint _ -> xs
  | Uvar e -> if mem e xs then xs else e :: xs

let make_nodes c = let f (C(_,s,d)) xs = add_elem (add_elem xs s) d in
                   LConstraints.fold f c []

exception Error

let make_edge = function
                  | C(LE, Uvar u, Uvar v) -> (u, v, 0)
                  | C(LE, Uint i, Uvar v) -> ("d0", v, -i)
                  | C(LE, Uvar u, Uint j) -> (u, "d0", j)
                  | C(LT, Uvar u, Uvar v) -> (u, v, -1)
                  | C(LT, Uint i, Uvar v) -> ("d0", v, -(i + 1))
                  | C(LT, Uvar u, Uint j) -> (u, "d0", j - 1)
                  | _ -> raise Error


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
let make_edges cs = let cs = normalize cs in
                    let f c gr = (make_edge c) :: gr in
                    LConstraints.fold f cs []

let make_positives ns es = let f v ls = ("d0", v, 0) :: ls in
                           List.fold_right f ns es

let relax ns d (u, v, w) = if d.(pos v ns) > d.(pos u ns) + w then
                             d.(pos v ns) <- d.(pos u ns) + w

let check_cond ns d (u, v, w) = d.(pos v ns) <= d.(pos u ns) + w

(* ****************************************************************************
 * val has_negative_cycle : int array array -> bool
 *
 * returns whether the graph has a negative cycle
 *
 * ***************************************************************************)
let has_negative_cycle ns es = let d = Array.make (length ns) 0 in
                               d.(0) <- 0 ;
                               for i = 1 to length ns - 1 do
                                  List.iter (relax ns d) es;
                               done;
                               for_all (check_cond ns d) es


(* ****************************************************************************
 * val satisfiable : LConstraints -> bool
 *
 * returns whether the set of contraints is satisfiable or not
 *
 * ***************************************************************************)

let satisfiable cs = match check_and_remove_arith cs with
                     | None -> false
                     | Some c -> let es = make_edges cs in
                                 let ns = "d0" :: make_nodes cs in
                                 let es = make_positives ns es in
                                 has_negative_cycle ns es
