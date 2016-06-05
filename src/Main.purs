module Main where

import Control.Monad.Eff (Eff)
import Nabla.Parse (parse)
import Prelude

foreign import data WEBWORKER :: !

main :: forall e. Eff (webWorker :: WEBWORKER | e) Unit
main = serve (show <<< parse)

foreign import serve
  :: (String -> String)
  -> forall e. Eff (webWorker :: WEBWORKER | e) Unit
