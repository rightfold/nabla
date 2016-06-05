module Nabla.Environment
( Γ(Γ)
, resolve
) where

import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (fromMaybe)
import Nabla.Term (Term(..))
import Prelude

newtype Γ = Γ (Map String Term)

lookup :: String -> Γ -> Term
lookup k (Γ γ) = fromMaybe (Var k) (Map.lookup k γ)

resolve :: Term -> Γ -> Term
resolve (Var s) γ = lookup s γ
resolve (App f xs) γ = App (resolve f γ) (map (resolve `flip` γ) xs)

resolve n@(Num _) _ = n

resolve Pi _ = Pi
resolve E _  = E

resolve Add _ = Add
resolve Mul _ = Mul

resolve Pow _ = Pow
resolve Log _ = Log
