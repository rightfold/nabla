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
simplify' (App f xs) = App f' xs'
  where f'  =     simplify' f
        xs' = map simplify xs # if flat f' then (_ >>= flatten) else id
        flatten t@(App g xs) | g == f'   = xs
                             | otherwise = [t]
        flatten t = [t]
simplify' t = t

flat :: Term -> Boolean
flat Add = true
flat Mul = true
flat _ = false
