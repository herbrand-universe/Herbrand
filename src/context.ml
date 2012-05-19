
type context = {
  mutable global : (Term.name * (Term.term * Term.term * Constraints.LConstraints.t)) list;
  mutable local  : Term.term list;
}


let empty () = {global = []; local = []}

let addGlobal c n t ty constr = c.global <- (n, (t, ty, constr)) :: c.global; c

let addLocal c t = { c with local = (t :: c.local)}

let inLocal c i = i <= (List.length c.local)

let inGlobal c n = List.mem_assoc n c.global

let getType c n =   let _,ty,constr =  (List.assoc n c.global) in  ty, constr
let getDef  c n =   let t,_ ,_ =  (List.assoc n c.global) in  t

let getGlobal c n = List.assoc n c.global

let getLocal  c i = List.nth c.local (i-1)
