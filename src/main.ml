open Ast
open Term
open Format
open Constraints
open Typechecker
open Tests (* Al incluirlo se van a ejecutar los tests *)


type state = {
  mutable gamma : Context.context;
}

let state = {
  gamma = Context.empty ();
}



let pp_res fmt (a,b) = pp_term fmt a; pp_lconstr fmt b

(* Aca empieza todo a fines practicos *)
let main = function
(* | Gassume (n,t)     -> state.gamma <- (Context.addGlobal state.gamma n (toDeBruijn t))*)
 | Gdef (name, def)  -> ()
 | Gshow t           -> Format.printf "%a@\n" pp_term (toDeBruijn t)
 | Ginfer t          -> Format.printf "%a@\n" pp_res (typeof state.gamma (toDeBruijn t))
 | Gcheck (t1,t2)    -> Format.printf "%a@\n" pp_lconstr (downArr (toDeBruijn t1) (toDeBruijn t2))
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
