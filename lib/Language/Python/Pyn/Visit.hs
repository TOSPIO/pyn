{-# LANGUAGE BangPatterns      #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE NamedFieldPuns    #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE RecordWildCards   #-}

-----------------------------------------------------------------------------
-- |
-- Module      : Language.Python.Pyn.Visit
-- Copyright   : (c) 2016 Savor d'Isavano
-- License     : BSD3
-- Maintainer  : anohigisavay@gmail.com
-- Stability   : experimental
-- Portability : ghc
--
-- Traverse through the common AST and apply necessary transformations.
-----------------------------------------------------------------------------

module Language.Python.Pyn.Visit ( VisitOptions (..)
                                 , Visit
                                 , visit
                                 , typeCheck
                                 ) where

import           Control.Applicative
import           Control.Arrow
import           Data.Either.Unwrap
import           Data.Maybe
import           Language.Python.Common.AST   as AST
import           Language.Python.Common.Utils (str)
import           Language.Python.Pyn.Parser
import           Text.Printf

mkTypeCheckStmt :: String -> String -> String
mkTypeCheckStmt inst type_ = printf [str|
if not isinstance(%s, %s):
    raise TypeError("%s must be of type %s")
|] inst type_ inst type_

unknownFile :: String
unknownFile = "<unknown>"

-- TODO: Must be kidding me. Compose an AST by hand will ya?
typeCheck :: String -> String -> String -> [StatementSpan]
typeCheck (!inst) (!type_) (!fileName) =
  let (modSpan, _) = fromRight $ parseStmt (mkTypeCheckStmt inst type_) fileName
  in
  modSpan

data VisitOptions = VisitOptions { enableTypeCheck     :: Bool
                                 , reserveLocationInfo :: Bool
                                 }

data VisitAudit f = VAPure | VisitAudit

class Visit a where
  visit :: VisitOptions -> a -> a
  visit _ = id

instance (Visit a) => Visit [a] where
  visit opts = map (visit opts)

instance Visit ModuleSpan where
  visit opts (Module stmts) = Module $ map (visit opts) stmts

instance Visit StatementSpan where
  visit opts@VisitOptions {enableTypeCheck=True,..} f@Fun{..} =
    f { fun_name = visitOpts fun_name
      , fun_args = visitOpts fun_args
      , fun_result_annotation = Nothing
      , fun_body = funArgsToStmts fun_args ++ visitOpts fun_body
      , stmt_annot = stmt_annot
      }
      where
        visitOpts :: (Visit a) => a -> a
        visitOpts = visit opts
        extractParamIdentTypePair :: Parameter a -> (String, Maybe String)
        extractParamIdentTypePair = getParamIdent &&& getTypeIdent
          where
            getParamIdent = ident_string . param_name
            getTypeIdent = liftA (ident_string . var_ident) . param_py_annotation
        funArgsToStmts :: [ParameterSpan] -> [StatementSpan]
        funArgsToStmts =
          concatMap (\(ident, (Just type_)) -> typeCheck ident type_ unknownFile) .
          filter (isJust . snd) .
          map extractParamIdentTypePair

  visit _ a = a

instance Visit IdentSpan

instance Visit ParameterSpan where
  visit _ a@Param{..} = a{param_py_annotation=Nothing}
  visit _ a@VarArgsPos{..} = a{param_py_annotation=Nothing}
  visit _ a@VarArgsKeyword{..} = a{param_py_annotation=Nothing}
  visit _ x = x
