type context 

val empty : unit -> context

val addLocal : context -> Term.term -> context
val inLocal  : context -> int -> bool
val getLocal : context -> int -> Term.term

val inGlobal  : context -> Term.name -> bool
val addGlobal : context -> Term.name -> Term.term -> Term.term -> Constraints.LConstraints.t -> context
val getGlobal : context -> Term.name -> Term.term


