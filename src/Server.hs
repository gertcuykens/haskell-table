module Server (main) where

import Control.Exception     ( bracket )
import Data.Acid             ( AcidState )
import Data.Acid.Local       ( openLocalState, createCheckpointAndClose )
import Data.Acid.Remote      ( acidServer, sharedSecretCheck )
import Data.ByteString.Char8 ( pack )
import Data.Map              ( empty )
import Data.Set              ( singleton )
import Network               ( PortID(PortNumber) )
import Table                 ( UserMap(..) )

state :: IO (AcidState UserMap)
state = openLocalState $ UserMap empty

server :: AcidState UserMap -> IO ()
server = acidServer (sharedSecretCheck (singleton $ pack "12345")) (PortNumber 8080)

main :: IO ()
main = bracket
    state
    createCheckpointAndClose
    server

