module Parser where

import Lexer

data E = E1 Int E'
	   | E2 Int
data E' = E'1 Char 
		| E'2 E Char E'


