open Format

type point = int * int * int
type pos   = string * point * point

exception NotImplementedYet of string
exception ParseError        of pos * string
exception TypeError         of string


let pos_of_lex pos1 pos2 =
  let col p = p.Lexing.pos_cnum - p.Lexing.pos_bol in
  let line p = p.Lexing.pos_lnum in
  let pt1 = (pos1.Lexing.pos_cnum, line pos1, col pos1) in
  let pt2 = (pos2.Lexing.pos_cnum, line pos2, col pos2) in
  let pos = (pos1.Lexing.pos_fname, pt1, pt2) in
  pos

let pp_pos fmt (fname, (a1,l1,c1), (a2,l2,c2) as pos) =
  Format.fprintf fmt "Toplevel input, characters %d-%d" a1 a2



let catch_exn = function
  | NotImplementedYet msg   ->
    Format.printf "@{<error> Not Implemented Yet: %s@}@." msg
  | ParseError (pos, msg)   ->
    Format.printf "@{<error>%a:@\n@[<hov 2>Syntax error %s@]@}@." pp_pos pos msg
  | TypeError msg           ->
    Format.printf "@{<error> Type error: %s@}@." msg
  | _                       -> 
    Format.printf "@{<error> Unknown error@}@." 

let not_implemented fmt =
  let f _ =
    let msg = Format.flush_str_formatter () in raise (NotImplementedYet msg)
  in Format.kfprintf f Format.str_formatter fmt

let type_error fmt =
  let f _ =
    let msg = Format.flush_str_formatter () in raise (TypeError msg)
  in Format.kfprintf f Format.str_formatter fmt





