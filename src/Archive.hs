{-# LANGUAGE OverloadedStrings #-}
import Control.Exception     ( bracket )
import Data.Acid             ( AcidState, createCheckpoint, closeAcidState )
import Data.Acid.Advanced    ( query', update' )
import Data.Acid.Local       ( createArchive, openLocalState )
import Data.Acid.Remote      ( openRemoteState, sharedSecretPerform )
import Data.ByteString.Char8 ( pack )
import Data.Map              ( empty )
import Network               ( PortID(PortNumber) )
import Table                 ( UserMap(..), User(..), InsertKey(..), LookupKey(..))

main :: IO ()
main = do
    --acid <- openLocalState $ UserMap empty
    acid <- openRemoteState (sharedSecretPerform $ pack "12345") "localhost" (PortNumber 8080) :: IO (AcidState UserMap)
    --_ <- update' acid (InsertKey "123" (User "" "" "" ""))
    --_ <- query' acid (LookupKey "123")
    createCheckpoint acid
    closeAcidState acid

