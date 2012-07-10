open Ast
open Term

let rec prop2astTerm = function 
  | Ltrue -> prop2astTerm (Lforall ("X", prop, (Limp ((Lvar "X"), (Lvar "X")))))
  | Lfalse -> prop2astTerm (Lforall ("X", prop, (Lvar "X")))
  | Lvar n -> AVar n
  | Lnot p -> prop2astTerm (Limp (p, Lfalse))
  | Land (p, q) -> prop2astTerm (Lforall ("X", prop, (Limp ((Limp (p, (Limp (q, (Lvar "X"))))), (Lvar "X")))))
  | Lor  (p, q) -> prop2astTerm (Lforall ("X", prop, (Limp ((Limp ((Limp (p, (Lvar "X"))), (Limp (q, (Lvar "X"))))), (Lvar "X")))))
  | Limp (p, q) -> prop2astTerm (Lforall (("0$"), (prop2astTerm p), q))
  | Lforall (n, t, p) -> APi (n, t, prop2astTerm p)
  | Lexists (n, t, p) -> prop2astTerm (Lforall (("X"), prop, (Limp ((Lforall (n, t, (Limp (p, (Lvar "X"))))), (Lvar "X")))))
and prop = ASort AProp

let prop2term f = toDeBruijn (prop2astTerm f)
