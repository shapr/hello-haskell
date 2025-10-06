{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Core
import Data.List
import qualified Data.Text.IO as T
import Granite
import Prelude

main_ :: IO ()
main_ = do
    bookText <- readFile "74192.txt.utf-8" -- something you got from gutenberg.org
    let listOfWords = words bookText
        listOfDupes = group $ sort listOfWords
        countAndWord = map (\l -> (length l, head l)) listOfDupes
        orderedCounts = sort countAndWord
    print $ take 10 orderedCounts
    print $ take 10 $ reverse orderedCounts

main :: IO ()
main = T.putStrLn (bars [("Q1", 12), ("Q2", 18), ("Q3", 9), ("Q4", 15)] defPlot{plotTitle = "Sales"})
