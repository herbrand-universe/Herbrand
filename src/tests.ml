open Ast
open Term
open Context
open Typechecker

(******************************************************************************
 * Terms definitions 
 ******************************************************************************)

let prop = Sort Prop
let type0 = Sort (Type 0)
let type1 = Sort (Type 1)
let type2 = Sort (Type 2)
let type3 = Sort (Type 3)

let id_prop = (Lam (prop,Id 1))
let id_type0 = (Lam (type0,Id 1))
let id_type1 = (Lam (type1,Id 1))



(******************************************************************************
 * Tests: Is a pair of (Term, Type) 
 ******************************************************************************)
let test1 = (id_prop, Pi (prop,prop))
let test2 = (id_type0, Pi(type0,type0))
let test3 = (Sigma (prop, prop),type0)
let test4 = (Pi (prop,Id 1),prop)
let test5 = (Pi (prop,prop),type0)
let test6 = (Lam ((Sigma (prop,prop)),Fst (Id 1)),Pi((Sigma (prop,prop), prop)))

let test7 = (Inl (Sum(type0,type0),prop),(Sum(type0,type0)))

(******************************************************************************
 * val tests = (term, term) list
 *
 *   This function test [Typechecker.typeof] function. 
 * Should be a list of 'term' and the 'type' of this term.
 ******************************************************************************)
let tests =
  [ 
    prop,  type0;
    type0, type1;
    type1, type2;
    type2, type3;
    test1;
    test2;
    test3;
    test4;
    test5;
    test6;
    test7
  ]

(******************************************************************************
 * val result : (term * term) list -> (term * term * term) list
 *
 *  Return [(term, type)]  =  [(term , typeof term, type)]
 *
 ******************************************************************************)
let result t = 
  let f (a,b) = (a, typeof (empty ()) a , b) in
  List.map f t

(******************************************************************************
 * Print 
 *    
 ******************************************************************************)
let print (a,b,c) = 
  let show fmt t = pp_astTerm fmt t in
  if b = c then
    Format.printf "[OK!] Typeof [%a] is [%a]@\n" 
      show (fromDeBruijn a) show (fromDeBruijn b)
  else
    Format.printf "[Error] Typeof [%a] is [%a] instead of [%a]@\n"
      show (fromDeBruijn a) show (fromDeBruijn b) show (fromDeBruijn c)



(******************************************************************************
 *
 ******************************************************************************)
let check_all () = 
  List.iter print (result tests)


(* To Be Continued ... *)


