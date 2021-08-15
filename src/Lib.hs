-- {-# LANGUAGE DataKinds                  #-}
-- {-# LANGUAGE DeriveGeneric              #-}
-- {-# LANGUAGE GADTs                      #-}
-- {-# LANGUAGE GeneralizedNewtypeDeriving #-}
-- {-# LANGUAGE QuasiQuotes                #-}
-- {-# LANGUAGE TemplateHaskell            #-}
-- {-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE TypeSynonymInstances       #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
module Lib where

import Data.Proxy (Proxy(Proxy))
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)
import Servant
import Servant.Server (serve)
import Servant.Static.TH (createApiAndServerDecs)
import qualified Network.HTTP.Media            as M
import qualified Data.ByteString.Lazy.Char8       as BC
import qualified PdfSvg as P
import Control.Monad.IO.Class (liftIO)

$(createApiAndServerDecs "FrontEndApi" "frontEndServer" "webapp/dist")

data SVG

instance Accept SVG where
    contentType _ = "image" M.// "svg+xml"

instance MimeRender SVG String where
    mimeRender _ = BC.pack

type Api = FrontEndApi
      :<|> "book" :> Capture "pageNum" Int :> Get '[SVG] String

bookServer :: String -> Int -> Handler String
bookServer pdfFile n = do
  let svgFile = ("/tmp/serendipity_" <> show n <> ".svg")
  liftIO (P.pdf2svg pdfFile svgFile (fromIntegral n))
  content <- liftIO (readFile svgFile)
  return content

apiProxy :: Proxy Api
apiProxy = Proxy

apiServer :: String -> Server Api
apiServer pdfFile = frontEndServer :<|>
                    bookServer pdfFile

app :: String -> Application
app pdfFile = serve apiProxy (apiServer pdfFile)

startApp :: String -> IO ()
startApp pdfFile = do
  putStrLn $ "Serendipity serving '" <> pdfFile <> "' at http://localhost:8080/ ..."
  run 8080 $ app pdfFile
