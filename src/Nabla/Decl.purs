module Nabla.Decl
( Decl(..)
) where

import Nabla.Term (Term)

data Decl
  = ImportDecl (Array String) String
  | LetDecl String Term
  | AbstractDecl String
