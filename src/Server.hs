import Control.Exception     ( bracket )
import Data.Acid             ( AcidState, closeAcidState )
import Data.Acid.Local       ( openLocalState )
import Data.Acid.Remote      ( acidServer, sharedSecretCheck )
import Data.ByteString.Char8 ( pack )
import Data.Map              ( empty )
import Data.Set              ( singleton )
import Network               ( PortID(PortNumber) )
import Table                 ( GroupMap(..) )

openAcidState :: IO (AcidState GroupMap)
openAcidState = openLocalState $ GroupMap empty

runAcidState :: AcidState GroupMap -> IO ()
runAcidState = acidServer (sharedSecretCheck (singleton $ pack "12345")) (PortNumber 8080)

main :: IO ()
main = bracket openAcidState closeAcidState runAcidState

