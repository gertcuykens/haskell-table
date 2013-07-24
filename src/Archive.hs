import Control.Exception     ( bracket )
import Codec.Utils           ( Octet, toTwosComp )
import Data.Acid             ( AcidState, createCheckpoint, closeAcidState )
import Data.Acid.Advanced    ( query', update' )
--import Data.Acid.Local       ( createArchive, openLocalState )
import Data.Acid.Remote      ( openRemoteState, sharedSecretPerform )
import Data.ByteString.Char8 ( pack )
import Data.HMAC             ( hmac_sha1 )
import Network               ( PortID(PortNumber) )
import Table                 ( GroupMap(..), Group(..), InsertKey(..), LookupKey(..), group)

secret :: [Octet]
secret = toTwosComp 12345

message :: [Octet]
message = toTwosComp 12345

openAcidState :: IO (AcidState GroupMap)
openAcidState = openRemoteState (sharedSecretPerform $ pack "12345") "localhost" (PortNumber 8080)

runAcidState :: AcidState GroupMap -> IO ()
runAcidState acid = do
    _ <- update' acid (InsertKey 0 (Group [116469479527388802962,555]))
    _ <- update' acid (InsertKey 1 (Group [116469479527388802962]))
    _ <- update' acid (InsertKey 2 (Group [116469479527388802962]))
    _ <- update' acid (InsertKey 3 (Group [116469479527388802962]))
    Just p <- query' acid (LookupKey 0)
    print (116469479527388802962 `elem` group p)
    print (555 `elem` group p)
    print (666 `elem` group p)
    print (hmac_sha1 secret message)
    createCheckpoint acid

main :: IO ()
main = bracket openAcidState closeAcidState runAcidState

