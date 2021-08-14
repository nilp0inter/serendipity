{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Lib (app)
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON

main :: IO ()
main = hspec spec

spec :: Spec
spec = with (return app) $ do
    describe "GET /" $ do
        it "responds with 200" $ do
            get "/" `shouldRespondWith` 200
    describe "GET /index.html" $ do
        it "responds with 200" $ do
            get "/index.html" `shouldRespondWith` 200
    describe "GET /index.js" $ do
        it "responds with 200" $ do
            get "/index.js" `shouldRespondWith` 200
