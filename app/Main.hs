module Main where

import Visualizer
import System.Environment (getArgs)
import Lexer
import Data.Text.Lazy (pack)
import Parser
import Data.Bifunctor
import Control.Monad (join)

main :: IO ()
main = do 
	args <- getArgs
	content <- readFile (args !! 0)
	case (join (toGraph <$> fst <$> (parseExpr (tokenizeAll (words content))))) of 
		Just x -> visualize x
		Nothing -> print "Did not match"

