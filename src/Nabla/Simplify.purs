module Nabla.Simplify
( simplify
) where

import Data.Array as Array
import Nabla.Polynomial (unpolynomial)
import Nabla.Term (Term(..))
import Prelude

simplify :: Term -> Term
simplify x = if simplified == x then x else simplify simplified
  where simplified = simplify' x

simplify' :: Term -> Term
simplify' (App Add [x, y]) | x == y = App Mul [Num 2, simplify' x]
simplify' (App Add xs) = App Add (xs # map simplify' # Array.sort)
simplify' (App Mul [x, y]) | x == y = App Pow [simplify' x, Num 2]
simplify' (App Mul xs) = App Mul (xs # map simplify' # Array.sort)
simplify' (App f xs) = App (simplify' f) (map simplify' xs)
simplify' t = t
