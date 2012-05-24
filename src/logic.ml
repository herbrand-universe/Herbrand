open Ast

type name = string

type prop =
  | Var of name
  | Not of prop
  | And of prop * prop
  | Or  of prop * prop
  | Imp of prop * prop
  | ForAll of name * prop * prop
  | Exists of name * prop * prop

let rec ast2prop = function 
  | Gvar n -> Var n
  | Gnot p -> Not (ast2prop p)
  | Gand (p, q) -> And ((ast2prop p), (ast2prop q))
  | Gor  (p, q) -> Or ((ast2prop p), (ast2prop q))
  | Gimp (p, q) -> Imp ((ast2prop p), (ast2prop q))
  | Gforall (n, p, q) -> ForAll (n, ast2prop p, ast2prop q)
  | Gexists (n, p, q) -> Exists (n, ast2prop p, ast2prop q)

