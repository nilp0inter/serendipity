module PdfSvg where

{-
 - This PoC is a Haskell translation of pdf2svg
 - https://github.com/dawbarton/pdf2svg
 - which is under GPL license.
 -}

import qualified GI.Poppler.Objects.Document as Document
import qualified GI.Poppler.Objects.Page as Page
import qualified GI.Cairo.Render as Render
import qualified GI.Cairo.Render.Connector as Conn
import Data.Text
import Data.Int

convertPage :: Page.Page -> FilePath -> IO ()
convertPage page svgFilename = do
  (width, height) <- Page.pageGetSize page
  -- putStrLn $ "Creating SVG (" <> show width <> "," <> show height <> ")"
  Render.withSVGSurface svgFilename width height $
    \surface -> do
      Render.renderWith surface $ do
        Conn.toRender $ Page.pageRenderForPrinting page
        Render.showPage
      Render.surfaceFinish surface


pdf2svg :: Text -> Text -> Int32 -> IO ()
pdf2svg pdfFile svgFile pageInd = do
  pdf <- Document.documentNewFromFile pdfFile Nothing
  page <- Document.documentGetPage pdf pageInd
  convertPage page (unpack svgFile)
