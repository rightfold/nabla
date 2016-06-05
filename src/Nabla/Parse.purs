module Nabla.Parse
( parse
) where

import Data.Maybe (Maybe(Just, Nothing))
import Nabla.Term (Term(..))

parse :: String -> Maybe (Array Term)
parse = parse' {just: Just, nothing: Nothing, var: Var, app: App}

foreign import parse'
  :: { just    :: forall a. a -> Maybe a
     , nothing :: forall a.      Maybe a
     , var     :: String -> Term
     , app     :: Term -> Array Term -> Term
     }
  -> String
  -> Maybe (Array Term)
