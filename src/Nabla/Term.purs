module Nabla.Term
( Term(..)
) where

-- | Denotes a mathematical object. Equality and ordering are structual;
-- | `0 + 1`, `1 + 0`, and `1` are considered distinct.
data Term
  = Var String

  | Num Number

  | Pi
  | E

  | Add Term Term
  | Mul Term Term

  | Pow Term Term
  | Log Term Term


