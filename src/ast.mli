
type global = 
   | Ginfer   of Term.term
   | Geq_term of Term.term * Term.term
   | Gwhnf    of Term.term
   | Gcheck   of Term.term * Term.term
   | Gassume of Term.name * Term.term
   | Gshow of Term.name
   | Gquit
