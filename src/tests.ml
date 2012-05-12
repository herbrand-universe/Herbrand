open Term
open Constraints

(* Definiciones sobre 'rel' *)
let rel1a = C (LT,Uint 1, Uint 2)
let rel2a = C (LT,Uint 1, Uint 1)
let rel3a = C (LE,Uint 1, Uint 2)
let rel4a = C (LE,Uint 2, Uint 2)
let rel5a = C (LE,Uint 3, Uint 2)
let rel6a = C (EQ,Uint 1, Uint 2)
let rel7a = C (EQ,Uint 3, Uint 3)

let rel1b = C (LT,Uvar "x", Uint 2)
let rel2b = C (LT,Uint 1, Uvar "y")
let rel3b = C (LE,Uvar "x", Uint 2)
let rel4b = C (LE,Uint 2, Uvar "z")
let rel5b = C (LE,Uvar "y", Uint 2)
let rel6b = C (EQ,Uint 1, Uvar "x")
let rel7b = C (EQ,Uint 3, Uvar "xx")

let rel1c = C (LT,Uvar "x", Uvar "x")
let rel2c = C (LT,Uvar "z", Uvar "y")
let rel3c = C (LE,Uvar "x", Uvar "z")
let rel4c = C (LE,Uvar "a", Uvar "z")
let rel5c = C (LE,Uvar "y", Uvar "b")
let rel6c = C (EQ,Uvar "z", Uvar "x")
let rel7c = C (EQ,Uvar "y", Uvar "xx")


(* Definiciones sobre 'lassignment' *)
let la1a = []
let la2a = [("x",2)]
let la3a = [("x",2); ("y",3)]
let la4a = [("x",2); ("y",3); ("z",0)]
let la5a = [("x",2); ("y",3); ("b",1)]


(* Tests sobre 'check_inequality'*)
let _ = assert (check_inequality la1a rel1a)
let _ = assert (not (check_inequality la2a rel1b))


(* To Be Continued ... *)


