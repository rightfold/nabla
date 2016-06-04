module Nabla.Term
( Term(..)
) where

data Term
  = Var String

  | Num Number

  | Pi
  | E

  | Add Term Term
  | Mul Term Term

  | Pow Term Term
  | Log Term Term
