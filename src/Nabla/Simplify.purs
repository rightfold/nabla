module Nabla.Simplify
( simplify
) where

import Data.Array as Array
import Nabla.Polynomial (unpolynomial)
import Nabla.Term (Term(..))
import Prelude

simplify :: Term -> Term
simplify = simplify'

simplify' :: Term -> Term
simplify' (App Add [x, y]) | x == y = App Mul [Num 2.0, simplify' x]
simplify' (App Add xs) = App Add (xs # map simplify' # Array.sort)
simplify' (App Mul xs) = App Mul (xs # map simplify' # Array.sort)
simplify' t = t
