module Nabla.Term
( Term(..)
) where

import Data.Generic (gCompare, class Generic, gEq)
import Prelude

-- | Denotes a mathematical object. Equality and ordering are structual;
-- | `0 + 1`, `1 + 0`, and `1` are considered distinct.
data Term
  = Var String
  | App Term (Array Term)

  | Num Number

  | Pi
  | E

  | Add
  | Mul

  | Pow
  | Log

derive instance genericTerm :: Generic Term

instance eqTerm :: Eq Term where eq = gEq

instance ordTerm :: Ord Term where compare = gCompare
