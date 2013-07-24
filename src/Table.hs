{-# LANGUAGE DeriveDataTypeable, TypeFamilies, TemplateHaskell#-}

module Table where

import Control.Lens ((?=), at, from, makeIso, view)
import Data.Acid (Update, Query, makeAcidic)
import Data.SafeCopy (deriveSafeCopy, base)
import Data.Typeable (Typeable)
import qualified Data.Map as Map (Map)

type User = Int
newtype Group = Group {group::[User]} deriving (Show, Typeable)

$(deriveSafeCopy 0 'base ''Group)

newtype GroupMap = GroupMap (Map.Map Int Group) deriving (Show, Typeable)

$(deriveSafeCopy 0 'base ''GroupMap)

$(makeIso ''GroupMap)

insertKey :: Int -> Group -> Update GroupMap ()
insertKey k v = (from groupMap.at k) ?= v

lookupKey :: Int -> Query GroupMap (Maybe Group)
lookupKey k = view (from groupMap.at k)

$(makeAcidic ''GroupMap ['insertKey, 'lookupKey])

