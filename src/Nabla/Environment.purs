module Nabla.Environment
( Γ(Γ)
, resolve
) where

import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(Just))
import Data.String (charAt)
import Data.Traversable (traverse)
import Nabla.Term (Term(..))
import Prelude

newtype Γ = Γ (Map String Term)

lookup :: String -> Γ -> Maybe Term
lookup k (Γ γ) =
  case charAt 0 k of
    Just c | c >= 'a' && c <= 'z' -> Just (Var k)
    _ -> Map.lookup k γ

resolve :: Term -> Γ -> Maybe Term
resolve (Var s) γ = lookup s γ
resolve (App f xs) γ = App <$> resolve f γ <*> traverse (resolve `flip` γ) xs

resolve n@(Num _) _ = Just n

resolve Pi _ = Just Pi
resolve E  _ = Just E

resolve Add _ = Just Add
resolve Mul _ = Just Mul

resolve Neg _ = Just Neg

resolve Pow _ = Just Pow
resolve Log _ = Just Log
