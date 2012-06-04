type context 

val empty : unit -> context

val addLocal : context -> Term.term -> context
val inLocal  : context -> int -> bool
val getLocal : context -> int -> Term.term

val inGlobal  : context -> Term.name -> bool
val addGlobal : context -> Term.name -> Term.term -> Term.term -> context
val getDef : context -> Term.name -> Term.term
val getType : context -> Term.name -> Term.term 
val getGlobal : context -> Term.name -> Term.term * Term.term 

val whnf : context -> Term.term -> Term.term
val whnf_is_kind : context -> Term.term -> bool
val get_whnf_kind : context -> Term.term -> Term.sort
val get_whnf_pi : context -> Term.term -> Term.term * Term.term
val get_whnf_sigma : context -> Term.term -> Term.term * Term.term

