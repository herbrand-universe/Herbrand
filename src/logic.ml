open Ast
open Term

let rec prop2astTerm = function 
  | Gtrue -> prop2astTerm (Gforall (("X"), (ASort AProp), (Gimp ((Gvar "X"), (Gvar "X")))))
  | Gfalse -> prop2astTerm (Gforall (("X"), (ASort AProp), (Gvar "X")))
  | Gvar n -> AVar n
  | Gnot p -> prop2astTerm (Gimp (p, Gfalse))
  | Gand (p, q) -> prop2astTerm (Gforall (("X"), (ASort AProp), (Gimp ((Gimp (p, (Gimp (q, (Gvar "X"))))), (Gvar "X")))))
  | Gor  (p, q) -> prop2astTerm (Gforall (("X"), (ASort AProp), (Gimp ((Gimp ((Gimp (p, (Gvar "X"))), (Gimp (q, (Gvar "X"))))), (Gvar "X")))))
  | Gimp (p, q) -> prop2astTerm (Gforall (("0$"), (prop2astTerm p), q))
  | Gforall (n, t, p) -> APi (n, t, (prop2astTerm p))
  | Gexists (n, t, p) -> prop2astTerm (Gforall (("X"), (ASort AProp), (Gimp ((Gforall (n, t, (Gimp (p, (Gvar "X"))))), (Gvar "X")))))

let prop2term f = toDeBruijn (prop2astTerm f)