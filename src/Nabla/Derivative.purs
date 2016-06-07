module Nabla.Derivative
( derivative
) where

import Data.Array as Array
import Data.Foldable (foldl)
import Data.Maybe (Maybe(Just, Nothing))
import Data.Traversable (traverse)
import Nabla.Term (Term(..))
import Prelude

derivative :: String -> Term -> Maybe Term
derivative x (Var v) | v == x    = Just (Num one)
                     | otherwise = Just (Num zero)
derivative x (App Add xs) = App Add <$> traverse (derivative x) xs
derivative x (App Mul xs) =
  case foldl go {nx: zero, r: []} xs of
    {nx, r} -> Just $ App Mul ([Num nx, App Pow [Var x, Num (nx - one)]] <> r)
  where go {nx, r} t | t == Var x = {nx: nx + one, r}
                     | otherwise  = {nx, r: Array.cons t r}

derivative _ (Num _) = Just (Num zero)

derivative _ Pi = Just (Num zero)
derivative _ E  = Just (Num zero)

derivative _ _ = Nothing
