module Parser where

import Lexer
import Data.Bifunctor

data Expr = Expr Int ERem         deriving Show
data ERem = ERem E' | Eps         deriving Show
data E'   = E' Int ERem Char ERem deriving Show

parseExpr :: [Token] -> Maybe (Expr, [Token])
parseExpr (Number n : rem) = first (Expr n) <$> parseERem rem 
parseExpr _ = Nothing

parseERem :: [Token] -> Maybe (ERem, [Token])
parseERem lst@(Number n : xs) = first ERem <$> parseE' lst
parseERem lst = Just (Eps, lst)

parseE' :: [Token] -> Maybe (E', [Token])
parseE' (Number n : rem) = do 
							(expr, Operand c : rem2) <- parseERem rem
							(expr2, rem3) <- parseERem rem2
							return (E' n expr c expr2, rem3)
parseE' _ = Nothing

