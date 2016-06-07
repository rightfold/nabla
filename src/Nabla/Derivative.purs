module Nabla.Derivative
( derivative
) where

import Data.Maybe (Maybe(Just, Nothing))
import Nabla.Term (Term(..))
import Prelude

derivative :: Term -> String -> Maybe Term
derivative (Var v) x | v == x    = Just (Num one)
                     | otherwise = Just (Var v)
derivative _ _ = Nothing
