module Main where

import System.Environment
import Language.Python.Pyn.Parser ( parseModule
                                  )
import Language.Python.Common.PrettyAST ()
import Language.Python.Common.Pretty ( prettyText
                                     )

nextLine = print $ replicate 20 '='

main :: IO ()
main = do
  args <- getArgs
  let fn = head args
  content <- readFile fn
  let (Right (ast, _)) = parseModule content fn
  print ast
  nextLine
  putStrLn $ prettyText ast
