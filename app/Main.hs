module Main where

import Lib
import System.Environment (getArgs)
import Lexer
import Parser

main :: IO ()
main = do 
	args <- getArgs
	content <- readFile (args !! 0)
	print (parseExpr (tokenizeAll (words content)))

