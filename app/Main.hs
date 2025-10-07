{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Core
import Data.List
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Granite
import Prelude

import System.Console.Terminal.Size
import System.Environment

main :: IO ()
main = do
    (Just (Window{height = h, width = w})) <- size
    TIO.putStrLn $ lineGraph (coffeeChart 10) (defP "Coffee Temp" w h)

-- T.putStrLn $ lineGraph waterInTubChart (defP "Water In Tub" w h)

waterInTubChart = [("Water in Tub", [(x, waterInTub' 1 x) | x <- [0 .. 10]])]

coffeeChart n =
    let coffee = coffeeLine 10
     in [ coffee 100
        , coffee 80
        , coffee 60
        , coffee 40
        , coffee 10
        , coffee 5
        , coffee 0
        ]

-- steps, starting temp
coffeeLine n startTemp = ("Temp from " <> T.pack (show n), zip [0 .. n] (iterate (coffeeTemp 18 0.1) startTemp))

-- params are title, width, and height
-- origin is forced to 0,0 for both x and y axis
defP title w h = defPlot{plotTitle = title, widthChars = w - 10, heightChars = h - 10, xBounds = (Just 0, Nothing), yBounds = (Just 0, Nothing)}
