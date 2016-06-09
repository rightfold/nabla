module Nabla.Environment
( Γ(Γ)
, resolve
) where

import Data.Foldable (foldl)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(Just, Nothing))
import Data.String (charAt)
import Data.Traversable (traverse)
import Nabla.Term (Term(..))
import Prelude

newtype Γ = Γ (Map String Term)

lookup :: String -> Γ -> Maybe Term
lookup k (Γ γ) =
  case Map.lookup k γ of
    Just v -> Just v
    Nothing ->
      case charAt 0 k of
        Just c | c >= 'a' && c <= 'z' -> Just (Var k)
        _ -> Nothing

resolve :: Term -> Γ -> Maybe Term
resolve (Var s) γ = lookup s γ
resolve (App f xs) γ = App <$> resolve f γ <*> traverse (resolve `flip` γ) xs
resolve (Lam ps x) (Γ γ) =
  let γ' = foldl (\g p -> Map.insert p (Var p) g) γ ps
   in Lam ps <$> resolve x (Γ γ')

resolve n@(Num _) _ = Just n

resolve Pi _ = Just Pi
resolve E  _ = Just E

resolve Add _ = Just Add
resolve Mul _ = Just Mul

resolve Pow _ = Just Pow
resolve Log _ = Just Log

resolve Derivative _ = Just Derivative
resolve Lim _ = Just Lim
