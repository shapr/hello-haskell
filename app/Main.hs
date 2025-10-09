{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Core
import Data.List
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Granite
import TextShow
import Prelude

import System.Console.Terminal.Size (
    Window (Window, height, width),
    size,
 )

main :: IO ()
main = do
    (Just (Window{height = h, width = w})) <- size
    TIO.putStrLn $ lineGraph heatingChart (defPlot{plotTitle = "heating", widthChars = w - 10, heightChars = h - 10})

-- TIO.putStrLn $ lineGraph (coffeeChart 10) (defP "Coffee Temp" w h)

-- TIO.putStrLn $ lineGraph (bankChart 10) (defP "Account Balance" w h)

-- T.putStrLn $ lineGraph waterInTubChart (defP "Water In Tub" w h)

-- params are title, width, and height
-- origin is forced to 0,0 for both x and y axis
defP title w h = defPlot{plotTitle = title, widthChars = w - 10, heightChars = h - 10, xBounds = (Just 0, Nothing), yBounds = (Just 0, Nothing)}
