module Main where

import Lib
import System.Environment (getArgs)
import Lexer

main :: IO ()
main = do 
	args <- getArgs
	content <- readFile (args !! 0)
	print (tokenizeAll (words content))
