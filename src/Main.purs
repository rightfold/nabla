module Main where

import Control.Monad.Eff (Eff)
import Data.Map as Map
import Data.Maybe (maybe)
import Data.Tuple (Tuple(Tuple))
import Nabla.Environment (Γ(Γ), resolve)
import Nabla.Parse (parse)
import Nabla.Simplify (simplify)
import Nabla.Term (showNabla, Term(..))
import Prelude

foreign import data WEBWORKER :: !

main :: forall e. Eff (webWorker :: WEBWORKER | e) Unit
main = serve ((parse >=> (resolve `flip` γ))
               >>> maybe "" (simplify >>> showNabla))
  where γ = Γ $ Map.fromFoldable [ Tuple "Pi" Pi
                                 , Tuple "E" E
                                 , Tuple "Add" Add
                                 , Tuple "Multiply" Mul
                                 , Tuple "Raise" Pow
                                 , Tuple "Log" Log
                                 , Tuple "Differentiate" Derivative
                                 ]

foreign import serve
  :: (String -> String)
  -> forall e. Eff (webWorker :: WEBWORKER | e) Unit
