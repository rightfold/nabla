module Nabla.Polynomial
( unpolynomial
) where

import Nabla.Term (Term(..))
import Prelude

-- | Returns the addends of the polynomial. The original polynomial can be
-- | reconstructed easily; no information is lost.
unpolynomial :: Term -> Array {factors :: Array Term, exponent :: Term}
unpolynomial = addends >>> map \a -> {factors: factors a, exponent: exponent a}

exponent :: Term -> Term
exponent (Pow _ e) = e
exponent _ = Num 1.0

factors :: Term -> Array Term
factors (Mul a b) = factors a <> factors b
factors n = [n]

addends :: Term -> Array Term
addends (Add a b) = addends a <> addends b
addends n = [n]
