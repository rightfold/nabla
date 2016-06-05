module Main where

import Control.Monad.Eff (Eff)
import Nabla.Parse (parse)
import Prelude

main :: forall e. Eff e Unit
main = serve (show <<< parse)

foreign import serve :: (String -> String) -> forall e. Eff e Unit
