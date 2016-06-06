module Nabla.Polynomial
( unpolynomial
) where

import Nabla.Term (Term(..))
import Prelude

-- | Returns the factors of the addends of the polynomial. The original
-- | polynomial can be reconstructed easily; no information is lost.
unpolynomial :: Term -> Array (Array {base :: Term, exponent :: Term})
unpolynomial = addends >>> map (factors >>> map \f -> {base: base f, exponent: exponent f})

exponent :: Term -> Term
exponent (App Pow [_, e]) = e
exponent _ = Num 1

base :: Term -> Term
base (App Pow [b, _]) = b
base n = n

factors :: Term -> Array Term
factors (App Mul [a, b]) = factors a <> factors b
factors n = [n]

addends :: Term -> Array Term
addends (App Add [a, b]) = addends a <> addends b
addends n = [n]
