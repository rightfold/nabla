module Nabla.Term
( Term(..)

, showNabla
) where

import Data.BigInt (BigInt)
import Data.BigInt as BigInt
import Data.String as String
import Prelude

-- | Denotes a mathematical object. Equality and ordering are structural;
-- | `0 + 1`, `1 + 0`, and `1` are considered distinct.
data Term
  = Var String
  | App Term (Array Term)
  | Lam (Array String) Term

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

showNabla :: Term -> String
showNabla (Var x) = x
showNabla (App f xs) = "(" <> showNabla f <> ")[" <> String.joinWith ", " (map showNabla xs) <> "]"
showNabla (Lam ps x) = "fun[" <> String.joinWith ", " ps <> "] " <> showNabla x

showNabla (Num x) = BigInt.toString x

showNabla Pi = "Pi"
showNabla E  = "E"

showNabla Add = "Add"
showNabla Mul = "Multiply"

showNabla Pow = "Raise"
showNabla Log = "Log"

showNabla Derivative = "Differentiate"
