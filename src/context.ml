
type context = {
  mutable global : (Term.name * Term.term) list;
  mutable local  : Term.term list;
}


let empty () = {global = []; local = []}

let addGlobal c n t = c.global <- (n , t) :: c.global; c

let addLocal c t = c.local <- (t :: c.local); c

let inLocal c i = i <= (List.length c.local)

let inGlobal c n = List.mem_assoc n c.global


let getGlobal c n = List.assoc n c.global

let getLocal  c i = List.nth c.local (i-1)
