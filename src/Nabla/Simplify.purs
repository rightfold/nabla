module Nabla.Simplify
( simplify
) where

import Data.Array as Array
import Data.Array.Partial as Array.Partial
import Data.BigInt (BigInt)
import Data.BigInt as BigInt
import Data.Foldable (any, foldl)
import Data.List (List(Cons, Nil))
import Data.Map as Map
import Data.Maybe (Maybe(Just, Nothing))
import Nabla.Derivative (derivative)
import Nabla.Environment (Γ(Γ), resolve)
import Nabla.Term (Term(..))
import Partial.Unsafe (unsafePartial)
import Prelude

simplify :: Term -> Term
simplify = go 128
  where go 0 x = x
        go n x = let simplified = simplify' x
                  in if simplified == x
                       then simplified
                       else go (n - 1) simplified

simplify' :: Term -> Term
simplify' t =
  t
  # simplifyAssociativity
  # simplifyGrouping
  # simplifyIdentity
  # simplifyConstants
  # simplifyCommutativity
  # simplifyUnaryApp
  # simplifyZeroProduct
  # simplifyDerivative
  # simplifyPower
  # simplifyLambdaCall
  # simplifyComponents

simplifyAssociativity :: Term -> Term
simplifyAssociativity (App f xs) | associative f = App f (xs >>= flatten)
  where flatten (App g ys) | g == f = ys >>= flatten
        flatten t = [t]
simplifyAssociativity t = t

simplifyGrouping :: Term -> Term
simplifyGrouping (App f xs) =
  case group f of
    Nothing -> App f xs
    Just g  -> let perGroup [x] = x
                   perGroup xs  = g (BigInt.fromInt $ Array.length xs)
                                    (unsafePartial $ Array.Partial.head xs)
                in App f $ map perGroup (Array.group' xs)
simplifyGrouping t = t

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
        {consts, rest} -> App f (Array.fromFoldable $ Cons (Num (foldl op id consts)) rest)
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
  | b == Num zero = Num zero
  | b == Num one  = Num one
  | e == Num zero = Num one
  | e == Num one  = b
  | otherwise = App Pow [b, e]
simplifyPower t = t

simplifyLambdaCall :: Term -> Term
simplifyLambdaCall (App (Lam ps b) xs)
  | Array.length ps == Array.length xs =
      case resolve b (Γ $ Map.fromFoldable (Array.zip ps xs)) of
        Nothing -> App (Lam ps b) xs
        Just r  -> r
simplifyLambdaCall t = t

simplifyComponents :: Term -> Term
simplifyComponents (App f xs) = App (simplify' f) (map simplify' xs)
simplifyComponents (Lam ps b) = Lam ps (simplify' b)
simplifyComponents t = t

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

group :: Term -> Maybe (BigInt -> Term -> Term)
group Add = Just \n t -> App Mul [Num n, t]
group Mul = Just \n t -> App Pow [t, Num n]
group _ = Nothing

equalsUnaryApp :: Term -> Boolean
equalsUnaryApp Add = true
equalsUnaryApp Mul = true
equalsUnaryApp _ = false
