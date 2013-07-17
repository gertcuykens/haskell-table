module Main (main) where

import Control.Exception     ( bracket )
import Data.Acid             ( AcidState )
import Data.Acid.Local       ( openLocalState, createCheckpointAndClose, createArchive )
import Data.Acid.Remote      ( acidServer, sharedSecretCheck )
import Data.ByteString.Char8 ( pack )
import Data.Map              ( empty )
import Data.Set              ( singleton )
import Network               ( PortID(PortNumber) )
import Table                 ( UserMap(..) )

closeLocalState :: AcidState UserMap -> IO ()
closeLocalState s = createCheckpointAndClose s >> createArchive s

main :: IO ()
main = bracket
    (openLocalState $ UserMap empty )
    closeLocalState
    (acidServer (sharedSecretCheck (singleton $ pack "12345")) (PortNumber 8080))

