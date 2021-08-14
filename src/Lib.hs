{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
module Lib where

import Data.Proxy (Proxy(Proxy))
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)
import Servant.Server (serve)
import Servant.Static.TH (createApiAndServerDecs)

$(createApiAndServerDecs "FrontEndApi" "frontEndServer" "webapp/dist")

app :: Application
app = serve (Proxy :: Proxy FrontEndApi) frontEndServer

startApp :: IO ()
startApp = run 8080 app
