module Nabla.Simplify
( simplify
) where

import Data.Array as Array
import Nabla.Term (Term(..))
import Prelude

simplify :: Term -> Term
simplify x = if simplified == x then x else simplify simplified
  where simplified = simplify' x

simplify' :: Term -> Term
simplify' (App f [App g [x]]) | ownInverse f && f == g = x
simplify' (App f xs) = App f' xs'
  where f'  =     simplify' f
        xs' = map simplify xs
              # (if flat f' then (_ >>= flatten) else id)
              # (if orderless f' then Array.sort else id)
        flatten t@(App g xs) | g == f'   = xs
                             | otherwise = [t]
        flatten t = [t]
simplify' t = t

flat :: Term -> Boolean
flat Add = true
flat Mul = true
flat _ = false

orderless :: Term -> Boolean
orderless Add = true
orderless Mul = true
orderless _ = false

ownInverse :: Term -> Boolean
ownInverse Neg = true
ownInverse _ = false
