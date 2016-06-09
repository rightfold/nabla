module Main where

import Control.Monad.Eff (Eff)
import Data.Map as Map
import Data.Maybe (Maybe(Just, Nothing), maybe)
import Data.Tuple (Tuple(Tuple))
import Nabla.Environment (Γ(Γ), resolve)
import Nabla.Parse (parseTerm)
import Nabla.Simplify (simplify)
import Nabla.Term (showNabla, Term(..))
import Prelude

foreign import data WEBWORKER :: !

main :: forall e. Eff (webWorker :: WEBWORKER | e) Unit
main = serve go
  where go text =
          let parseResult = parseTerm text
           in case parseResult of
                Nothing -> "(no parse)"
                Just t  -> resolve t γ # maybe "" (simplify >>> showNabla)
        γ = Γ $ Map.fromFoldable [ Tuple "Pi" Pi
                                 , Tuple "E" E
                                 , Tuple "Add" Add
                                 , Tuple "Multiply" Mul
                                 , Tuple "Raise" Pow
                                 , Tuple "Log" Log
                                 , Tuple "Differentiate" Derivative
                                 , Tuple "Limit" Lim
                                 ]

foreign import serve
  :: (String -> String)
  -> forall e. Eff (webWorker :: WEBWORKER | e) Unit
