module Main where

import Control.Monad.Eff (Eff)
import Data.Map as Map
import Data.Tuple (Tuple(Tuple))
import Nabla.Environment (Γ(Γ), resolve)
import Nabla.Parse (parse)
import Nabla.Simplify (simplify)
import Nabla.Term (Term(..))
import Prelude

foreign import data WEBWORKER :: !

main :: forall e. Eff (webWorker :: WEBWORKER | e) Unit
main = serve (show <<< map (map (simplify <<< resolve `flip` γ)) <<< parse)
  where γ = Γ $ Map.fromFoldable [ Tuple "Pi" Pi
                                 , Tuple "E" E
                                 , Tuple "Add" Add
                                 , Tuple "Multiply" Mul
                                 , Tuple "Raise" Pow
                                 , Tuple "Log" Log
                                 ]

foreign import serve
  :: (String -> String)
  -> forall e. Eff (webWorker :: WEBWORKER | e) Unit
