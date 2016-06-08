module Data.BigInt
( BigInt
, fromInt
, fromString
, toString
) where

import Data.Maybe (Maybe(Just, Nothing))
import Prelude

foreign import data BigInt :: *

fromInt :: Int -> BigInt
fromInt = fromIntImpl

fromString :: String -> Maybe BigInt
fromString = fromStringImpl Just Nothing

toString :: BigInt -> String
toString = toStringImpl

instance showBigInt :: Show BigInt where
  show = showImpl

instance semiringBigInt :: Semiring BigInt where
  one = oneImpl
  mul = mulImpl
  zero = zeroImpl
  add = addImpl

instance ringBigInt :: Ring BigInt where
  sub = subImpl

instance eqBigInt :: Eq BigInt where
  eq = eqImpl

instance ordBigInt :: Ord BigInt where
  compare = compareImpl [LT, EQ, GT]

foreign import oneImpl :: BigInt
foreign import mulImpl :: BigInt -> BigInt -> BigInt
foreign import zeroImpl :: BigInt
foreign import addImpl :: BigInt -> BigInt -> BigInt

foreign import subImpl :: BigInt -> BigInt -> BigInt

foreign import fromIntImpl :: Int -> BigInt

foreign import fromStringImpl
  :: (forall a. a -> Maybe a)
  -> (forall a. Maybe a)
  -> String
  -> Maybe BigInt

foreign import toStringImpl
  :: BigInt
  -> String

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
