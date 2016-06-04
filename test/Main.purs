module Test.Main where

import Control.Monad.Eff (Eff)
import Prelude

main :: forall e. Eff e Unit
main = pure unit
