module Lexer where

data Token = Number Int 
		   | Operand Char 
	       deriving Show

tokenizeAll :: [String] -> [Token]
tokenizeAll = map tokenize

tokenize :: String -> Token
tokenize str | isOperand str = Operand (str !! 0) -- good style detected
			 | otherwise 	 = Number (read str) -- yet another stylish line
			
isOperand :: String -> Bool
isOperand str = elem (str !! 0) "+-*/"
