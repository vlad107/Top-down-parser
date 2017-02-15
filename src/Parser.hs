module Parser where

import Lexer
import Data.Bifunctor
import Data.Text.Lazy (Text, pack)

class ToGraph a where 
	toGraphDef :: a -> Int -> Maybe (Int, [(Int, Text)], [(Int, Int)])
	toGraph :: a -> Maybe ([(Int, Text)], [(Int, Int, Text)])
	toGraph e = do 
				(cur, vs, es) <- toGraphDef e 0
				return (vs, [(a, b, pack "") | (a, b) <- es])

data Expr = Expr Int ERem         deriving Show
data ERem = ERem E' | Eps         deriving Show
data E'   = E' Int ERem Char ERem deriving Show

instance ToGraph Expr where 
	toGraphDef (Expr n erem) cur = do
									(cur', vs, es) <- toGraphDef erem cur
									return (cur' + 1, [(cur', pack "Expr")] ++ vs, [(cur', cur' - 1)] ++ es)

instance ToGraph ERem where 
	toGraphDef (ERem e') cur = do
								(cur', vs, es) <- toGraphDef e' cur
								return (cur' + 1, [(cur', pack "ERem")] ++ vs, [(cur', cur' - 1)] ++ es)
	toGraphDef _ cur = Just (cur + 1, [(cur, pack "Eps")], [])
								
instance ToGraph E' where
	toGraphDef (E' n erem1 o erem2) cur = do
											(cur', vs, es)    <- toGraphDef erem1 cur
											(cur'', vs', es') <- toGraphDef erem2 cur'
											return (cur'' + 3, 
													[(cur'' + 2, pack "E'")] ++ [(cur'' + 1, pack $ show n)] ++ [(cur'', pack $ show o)] ++ vs ++ vs', 
													[(cur'' + 2, cur'' + 1)] ++ [(cur'' + 2, cur'' - 1)] ++ [(cur'' + 2, cur'')] ++ [(cur'' + 2, cur' - 1)] ++ es ++ es')



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

