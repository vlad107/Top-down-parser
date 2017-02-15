module Main where

import Lib
import System.Environment (getArgs)

main :: IO ()
main = do 
	args <- getArgs
	content <- readFile (args !! 0)
	putStrLn (unwords (words content))
