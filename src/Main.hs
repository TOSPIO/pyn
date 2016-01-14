module Main where

import System.Environment
import Language.Python.Pyn.Parser ( parseModule
                                  )
import Language.Python.Common.PrettyAST ()
import Language.Python.Common.Pretty ( prettyText
                                     )
import Language.Python.Pyn.Visit ( visit
                                 , Visit ()
                                 , VisitOptions (..))


splitto = putStrLn $ replicate 20 '='

main :: IO ()
main = do
  args <- getArgs
  let fn = head args
  content <- readFile fn
  let pm = parseModule content fn
  let (Right (ast, additions)) = pm
  let ast' = visit (VisitOptions {enableTypeCheck=True}) ast
  putStrLn $ prettyText ast'
