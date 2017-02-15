module Lexer where

data Token = Number Int 
		   | Operand Char 
	       deriving Show

tokenizeAll :: [String] -> [Token]
tokenizeAll = map tokenize

tokenize :: String -> Token
tokenize str 
	| Just op <- toOperand str = Operand op
	| otherwise 			   = Number (read str)

toOperand :: String -> Maybe Char
toOperand [] = Nothing
toOperand (x:_) 
	| x `elem` "+-*/" = Just x
	| otherwise 	  = Nothing

