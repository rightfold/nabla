module Nabla.Parse
( parse
) where

import Data.BigInt (BigInt)
import Data.Maybe (Maybe(Just, Nothing))
import Nabla.Term (Term(..))

parse :: String -> Maybe Term
parse = parse' {just: Just, nothing: Nothing, var: Var, app: App, num: Num}

foreign import parse'
  :: { just    :: forall a. a -> Maybe a
     , nothing :: forall a.      Maybe a
     , var     :: String -> Term
     , app     :: Term -> Array Term -> Term
     , num     :: BigInt -> Term
     }
  -> String
  -> Maybe Term
