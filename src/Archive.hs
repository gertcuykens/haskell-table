import Control.Exception     ( bracket )
import Data.Acid             ( AcidState, createCheckpoint, closeAcidState )
import Data.Acid.Advanced    ( query', update' )
--import Data.Acid.Local       ( createArchive, openLocalState )
import Data.Acid.Remote      ( openRemoteState, sharedSecretPerform )
import Data.ByteString.Char8 ( pack )
import Network               ( PortID(PortNumber) )
import Table                 ( UserMap(..), User(..), InsertKey(..), LookupKey(..))

openAcidState :: IO (AcidState UserMap)
openAcidState = openRemoteState (sharedSecretPerform $ pack "12345") "localhost" (PortNumber 8080)

runAcidState :: AcidState UserMap -> IO ()
runAcidState acid = do
    _ <- update' acid (InsertKey 1 (User "" "" ["User"]))
    _ <- update' acid (InsertKey 2 (User "" "" ["User"]))
    _ <- update' acid (InsertKey 3 (User "" "" ["User"]))
    _ <- update' acid (InsertKey 4 (User "" "" ["User"]))
    p <- query' acid (LookupKey 4)
    print p
    createCheckpoint acid

main :: IO ()
main = bracket openAcidState closeAcidState runAcidState

