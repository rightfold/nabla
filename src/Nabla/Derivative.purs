module Nabla.Derivative
( derivative
) where

import Data.Maybe (Maybe(Nothing))
import Nabla.Term (Term(..))
import Prelude

derivative :: String -> Term -> Maybe Term
derivative _ _ = Nothing
