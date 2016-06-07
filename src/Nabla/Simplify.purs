module Nabla.Simplify
( simplify
) where

import Data.Array as Array
import Data.BigInt as BigInt
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
simplify' t = t

simplifyAssociativity :: Term -> Term
simplifyAssociativity = id

simplifyIdentity :: Term -> Term
simplifyIdentity (App f xs) =
  case identity f of
    Nothing -> App f xs
    Just x  -> App f (Array.filter (_ /= x) xs)
simplifyIdentity t = t

simplifyCommutativity :: Term -> Term
simplifyCommutativity = id

simplifyConstants :: Term -> Term
simplifyConstants = id

identity :: Term -> Maybe Term
identity Add = Just (Num BigInt.zero)
identity Mul = Just (Num BigInt.one)
identity _ = Nothing
