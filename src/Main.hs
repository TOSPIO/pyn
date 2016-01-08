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
  let (Right (ast, additions)) = parseModule content fn
  let ast' = visit (VisitOptions []) ast
  print ast'
  splitto
  print additions
  splitto
  putStrLn $ prettyText ast'
  splitto
  putStrLn "Goodbye"
