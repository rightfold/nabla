module Nabla.LaTeX
( toLaTeX
) where

import Data.String as String
import Nabla.Term (Term(..))
import Prelude

toLaTeX :: Term -> String
toLaTeX (Var x) = x
toLaTeX (App Add [a, b]) = "(" <> toLaTeX a <> ")+(" <> toLaTeX b <> ")"
toLaTeX (App Mul [a, b]) = "(" <> toLaTeX a <> ")(" <> toLaTeX b <> ")"
toLaTeX (App Pow [b, e]) = "(" <> toLaTeX b <> ")^{" <> toLaTeX e <> "}"
toLaTeX (App Log [b, x]) = "\\log_{" <> toLaTeX b <> "}(" <> toLaTeX x <> ")"
toLaTeX (App f xs) = toLaTeX f <> "(" <> String.joinWith ", " (map toLaTeX xs) <> ")"

toLaTeX (Num n) = show n

toLaTeX Pi = "\\pi"
toLaTeX E = "e"

toLaTeX Add = "\\mathtt{+}"
toLaTeX Mul = "\\mathtt{*}"

toLaTeX Pow = "\\mathtt{\\hat{}}"
toLaTeX Log = "\\mathtt{Log}"
