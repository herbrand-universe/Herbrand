open Ast
open Term
open Logic
open Format
open Typechecker
open Tests (* Al incluirlo se van a ejecutar los tests *)

module C = Context

type state = {
  mutable gamma : C.context;
}

let state = {
  gamma = C.empty ();
}


let process_def (n, def) =
  try
    let t = toDeBruijn def in
    let ty = typeof state.gamma t in
    let k = typeof state.gamma ty in
    C.get_whnf_kind state.gamma k;
    state.gamma <- (C.addGlobal state.gamma n t ty)
  with _ -> Format.printf "Term not well typed!@\n"
  

(* Aca empieza todo a fines practicos *)
let main = function
(* | Gassume (n,t)     -> state.gamma <- (Context.addGlobal state.gamma n (toDeBruijn t))*)
 | Gdef  (n,t) when not (C.inGlobal state.gamma n)    -> process_def (n,t) 
 | Gdef  (n,_)       -> Format.printf "The name [%s] is alredy in use@\n" n
 | Gproof (n,p)      -> Format.printf "%a@\n" pp_astTerm (fromDeBruijn (prop2term p))
 | Gshow t           -> Format.printf "%a@\n" pp_astTerm (fromDeBruijn (toDeBruijn t))
 | Ginfer t          -> Format.printf "%a@\n" pp_astTerm (fromDeBruijn (typeof state.gamma (toDeBruijn t)))
 | Gquit             -> raise Lexer.Eof
 | _                 -> () 



(* Esta choto pero no importa ... ya lo pondre lindo :) *)
let parse () = 
  let rec parse_and_catch () =
    try
      let lexbuf = Lexing.from_channel stdin in
      printf "Herbrand> @?";
      let global = Parser.global Lexer.token lexbuf in
        main global;
        parse_and_catch () 
    with
      | Lexer.Eof -> exit 0 
      | e -> printf "Error\n";(*catch_exn e *)parse_and_catch () 
  in parse_and_catch ()

let _ = parse ()
