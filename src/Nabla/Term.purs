module Nabla.Term
( Term(..)
) where

import Data.BigInt (BigInt)
import Prelude

-- | Denotes a mathematical object. Equality and ordering are structural;
-- | `0 + 1`, `1 + 0`, and `1` are considered distinct.
data Term
  = Var String
  | App Term (Array Term)

  | Num BigInt

  | Pi
  | E

  | Add
  | Mul

  | Pow
  | Log

  | Derivative

derive instance eqTerm :: Eq Term

derive instance ordTerm :: Ord Term
