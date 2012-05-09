open Ast
open Format
open Pretty


let main = function
 | Ginfer t            -> Format.printf "%a@\n" pp_term t
 | Gquit               -> raise Lexer.Eof
 | g -> Format.printf "Termino = [%a] @." pp_global g 


let parse () = 
  let rec parse_and_catch () =
    try
      let lexbuf = Lexing.from_channel stdin in
      printf "Herbrand>@?";
      let global = Parser.global Lexer.token lexbuf in
        main global;
        parse_and_catch () 
    with
      | Lexer.Eof -> exit 0 
      | e -> printf "Error\n";(*catch_exn e *)parse_and_catch () 
  in parse_and_catch ()

let _ = parse ()
