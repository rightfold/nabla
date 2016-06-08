module Nabla.Simplify
( simplify
) where

import Data.Array as Array
import Data.BigInt (BigInt)
import Data.Foldable (any, foldl)
import Data.List (List(Cons, Nil))
import Data.Maybe (Maybe(Just, Nothing))
import Nabla.Derivative (derivative)
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
  # simplifyConstants
  # simplifyCommutativity
  # simplifyUnaryApp
  # simplifyZeroProduct
  # simplifyDerivative
  # simplifyPower
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

simplifyConstants :: Term -> Term
simplifyConstants (App f xs) =
  case foldConstants f of
    Nothing -> App f xs
    Just {op, id} ->
      case partition xs of
        {consts: Nil} -> App f xs
        {consts, rest} -> App f (Array.cons (Num (foldl op id consts)) (Array.fromFoldable rest))
  where partition = foldl go {consts: Nil, rest: Nil}
          where go {consts, rest} (Num x) = {consts: Cons x consts, rest}
                go {consts, rest} t       = {consts, rest: Cons t rest}
simplifyConstants t = t

simplifyCommutativity :: Term -> Term
simplifyCommutativity (App f xs) | commutative f = App f (Array.sort xs)
simplifyCommutativity t = t

simplifyUnaryApp :: Term -> Term
simplifyUnaryApp (App f [x]) | equalsUnaryApp f = x
simplifyUnaryApp t = t

simplifyZeroProduct :: Term -> Term
simplifyZeroProduct (App Mul xs) | any (_ == Num zero) xs = Num zero
simplifyZeroProduct t = t

simplifyDerivative :: Term -> Term
simplifyDerivative (App Derivative [f, Var x]) =
  case derivative x f of
    Just d  -> d
    Nothing -> App Derivative [f, Var x]
simplifyDerivative t = t

simplifyPower :: Term -> Term
simplifyPower (App Pow [b, e])
  | e == Num zero = Num one
  | e == Num one = b
  | otherwise = App Pow [b, e]
simplifyPower t = t

associative :: Term -> Boolean
associative Add = true
associative Mul = true
associative _ = false

identity :: Term -> Maybe Term
identity Add = Just (Num zero)
identity Mul = Just (Num one)
identity _ = Nothing

foldConstants :: Term -> Maybe {op :: BigInt -> BigInt -> BigInt, id :: BigInt}
foldConstants Add = Just {op: (+) :: BigInt -> BigInt -> BigInt, id: zero :: BigInt}
foldConstants Mul = Just {op: (*) :: BigInt -> BigInt -> BigInt, id: one :: BigInt}
foldConstants _ = Nothing

commutative :: Term -> Boolean
commutative Add = true
commutative Mul = true
commutative _ = false

equalsUnaryApp :: Term -> Boolean
equalsUnaryApp Add = true
equalsUnaryApp Mul = true
equalsUnaryApp _ = false
