module Nabla.Simplify
( simplify
) where

import Data.Array as Array
import Data.BigInt as BigInt
import Data.Foldable (any)
import Data.Maybe (Maybe(Just, Nothing))
import Nabla.Term (Term(..))
import Prelude

simplify :: Term -> Term
simplify x = if simplified == x then x else simplify simplified
  where simplified = simplify' x

simplify' :: Term -> Term
simplify' (App f xs) =
  App (simplify' f) (simplify' <$> xs)
  # simplifyAssociativity
  # simplifyIdentity
  # simplifyCommutativity
  # simplifyConstants
  # simplifyZeroProduct
  # simplifyUnaryApp
simplify' t = t

simplifyAssociativity :: Term -> Term
simplifyAssociativity (App f xs) | associative f = App f (xs >>= flatten)
  where flatten (App g ys) | g == f = ys
        flatten t = [t]
simplifyAssociativity t = t

simplifyIdentity :: Term -> Term
simplifyIdentity (App f []) =
  case identity f of
    Nothing -> App f []
    Just x  -> x
simplifyIdentity (App f xs) =
  case identity f of
    Nothing -> App f xs
    Just x  -> App f (Array.filter (_ /= x) xs)
simplifyIdentity t = t

simplifyCommutativity :: Term -> Term
simplifyCommutativity (App f xs) | commutative f = App f (Array.sort xs)
simplifyCommutativity t = t

simplifyConstants :: Term -> Term
simplifyConstants = id

simplifyZeroProduct :: Term -> Term
simplifyZeroProduct (App Mul xs) | any (_ == Num BigInt.zero) xs = Num BigInt.zero
simplifyZeroProduct t = t

simplifyUnaryApp :: Term -> Term
simplifyUnaryApp (App f [x]) | equalsUnaryApp f = x
simplifyUnaryApp t = t

associative :: Term -> Boolean
associative Add = true
associative Mul = true
associative _ = false

identity :: Term -> Maybe Term
identity Add = Just (Num BigInt.zero)
identity Mul = Just (Num BigInt.one)
identity _ = Nothing

commutative :: Term -> Boolean
commutative Add = true
commutative Mul = true
commutative _ = false

equalsUnaryApp :: Term -> Boolean
equalsUnaryApp Add = true
equalsUnaryApp Mul = true
equalsUnaryApp _ = false
