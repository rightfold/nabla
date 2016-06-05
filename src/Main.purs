module Main where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Nabla.Parse (parse)
import Prelude

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = log $ show $ parse "(f g (h i) j) k (l m) n"
