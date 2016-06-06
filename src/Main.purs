module Main where

import Control.Monad.Eff (Eff)
import Data.Map as Map
import Data.Maybe (maybe)
import Data.Tuple (Tuple(Tuple))
import Nabla.Environment (Γ(Γ), resolve)
import Nabla.LaTeX (toLaTeX)
import Nabla.Parse (parse)
import Nabla.Simplify (simplify)
import Nabla.Term (Term(..))
import Prelude

foreign import data WEBWORKER :: !

main :: forall e. Eff (webWorker :: WEBWORKER | e) Unit
main = serve $ parse >>> maybe "" (    (resolve `flip` γ)
                                   >>> simplify
                                   >>> toLaTeX
                                  )
  where γ = Γ $ Map.fromFoldable [ Tuple "Pi" Pi
                                 , Tuple "E" E
                                 , Tuple "+" Add
                                 , Tuple "*" Mul
                                 , Tuple "^" Pow
                                 , Tuple "Log" Log
                                 ]

foreign import serve
  :: (String -> String)
  -> forall e. Eff (webWorker :: WEBWORKER | e) Unit
