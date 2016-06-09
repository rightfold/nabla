module Nabla.Parse
( parseDecls
, parseTerm
) where

import Data.BigInt (BigInt)
import Data.Maybe (Maybe(Just, Nothing))
import Nabla.Decl (Decl(..))
import Nabla.Term (Term(..))

parseDecls :: String -> Maybe (Array Decl)
parseDecls = parse "decls_top"

parseTerm :: String -> Maybe Term
parseTerm = parse "term_top"

parse :: forall a. String -> String -> Maybe a
parse s = parse' s { just: Just
                   , nothing: Nothing
                   , importDecl: ImportDecl
                   , letDecl: LetDecl
                   , abstractDecl: AbstractDecl
                   , var: Var
                   , app: App
                   , lam: Lam
                   , num: Num
                   }

foreign import parse'
  :: forall x
   . String
  -> { just         :: forall a. a -> Maybe a
     , nothing      :: forall a.      Maybe a
     , importDecl   :: Array String -> String -> Decl
     , letDecl      :: String -> Term -> Decl
     , abstractDecl :: String -> Decl
     , var          :: String -> Term
     , app          :: Term -> Array Term -> Term
     , lam          :: Array String -> Term -> Term
     , num          :: BigInt -> Term
     }
  -> String
  -> Maybe x
