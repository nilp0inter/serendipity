module Main where

import System.Environment
import Lib

main :: IO ()
main = do
  [pdfFile] <- getArgs
  startApp pdfFile
