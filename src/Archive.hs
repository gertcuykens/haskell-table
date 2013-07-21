module Archive (main) where

import Data.Acid             ( AcidState, createCheckpoint, closeAcidState )
import Data.Acid.Local       ( createArchive, openLocalState )
import Data.Map              ( empty )
import Table                 ( UserMap(..) )

main :: IO ()
main = do
    acid <- openLocalState $ UserMap empty
    createCheckpoint acid
    createArchive acid
    closeAcidState acid

