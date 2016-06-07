module Nabla.LaTeX
( toLaTeX
) where

import Data.String as String
import Nabla.Term (Term(..))
import Prelude

toLaTeX :: Term -> String
toLaTeX (Var x) = x
toLaTeX (App Add [a, b]) = paren 0x20 a <> "+" <> paren 0x20 b
toLaTeX (App Mul [a, b]) = paren 0x30 a <> "\\times " <> paren 0x30 b
toLaTeX (App Pow [b, e]) = paren 0x50 b <> "^{" <> toLaTeX e <> "}"
toLaTeX (App Log [b, x]) = "\\log_{" <> toLaTeX b <> "}" <> paren 0x40 x
toLaTeX (App f xs) = toLaTeX f <> "(" <> String.joinWith ", " (map toLaTeX xs) <> ")"

toLaTeX (Num n) = show n

toLaTeX Pi = "\\pi"
toLaTeX E = "e"

toLaTeX Add = "\\mathtt{+}"
toLaTeX Mul = "\\mathtt{*}"

toLaTeX Pow = "\\mathtt{\\hat{}}"
toLaTeX Log = "\\mathtt{Log}"

prec :: Term -> Int
prec (App Add _) = 0x20
prec (App Mul _) = 0x30
prec (App Pow _) = 0x50
prec (App Log _) = 0x40
prec (App _   _) = 0x00
prec _ = 0xf0

paren :: Int -> Term -> String
paren n t | prec t < n = "(" <> toLaTeX t <> ")"
          | otherwise  = toLaTeX t
