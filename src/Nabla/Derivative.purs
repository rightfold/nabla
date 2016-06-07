module Nabla.Derivative
( derivative
) where

import Data.Array as Array
import Data.Maybe (Maybe(Just, Nothing))
import Data.Traversable (traverse)
import Nabla.Term (Term(..))
import Prelude

derivative :: String -> Term -> Maybe Term
derivative x (Var v) | v == x    = Just (Num one)
                     | otherwise = Just (Num zero)
derivative x (App Add xs) = App Add <$> traverse (derivative x) xs
derivative x (App Mul xs) = Just $ App Mul (Array.filter (_ /= Var x) xs)

derivative _ (Num _) = Just (Num zero)

derivative _ Pi = Just (Num zero)
derivative _ E  = Just (Num zero)

derivative _ _ = Nothing
