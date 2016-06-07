module Data.BigInt
( BigInt
) where

import Data.Maybe (Maybe(Just, Nothing))
import Prelude

foreign import data BigInt :: *

fromString :: String -> Maybe BigInt
fromString = fromStringImpl Just Nothing

instance showBigInt :: Show BigInt where
  show = showImpl

instance eqBigInt :: Eq BigInt where
  eq = eqImpl

instance ordBigInt :: Ord BigInt where
  compare = compareImpl [LT, EQ, GT]

foreign import fromStringImpl
  :: (forall a. a -> Maybe a)
  -> (forall a. Maybe a)
  -> String
  -> Maybe BigInt

foreign import showImpl
  :: BigInt
  -> String

foreign import eqImpl
  :: BigInt
  -> BigInt
  -> Boolean

foreign import compareImpl
  :: Array Ordering
  -> BigInt
  -> BigInt
  -> Ordering
