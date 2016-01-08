{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE QuasiQuotes #-}

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
                                 , VisitOption (..)
                                 , Visit
                                 , visit
                                 ) where

import Language.Python.Common.AST as AST
import Language.Python.Common.Utils (str)
import Language.Python.Pyn.Parser
import Text.Printf

mkTypeCheckStmt :: String -> String -> String
mkTypeCheckStmt = printf [str|
if not isinstance(%s, %s):\"
    raise TypeError("%s must be of type")|]

unknownFile :: String
unknownFile = "<unknown>"

-- TODO: Must be kidding me. Compose an AST by hand will ya?
typeCheck :: String -> String -> Statement annot
typeCheck (!inst) (!t) = parseModule (mkTypeCheckStmt inst t) "<unknown>"

newtype VisitOptions = VisitOptions [VisitOption]

data VisitOption = EnableTypeCheck
                 | ReserveLocationInfo

data VisitAudit f = VAPure | VisitAudit


class Visit a where
  visit :: VisitOptions -> a -> a
  visit _ = id

instance (Visit a) => Visit [a] where
  visit opts = map (visit opts)

instance Visit (Module a) where
  visit opts (Module stmts) = Module $ map (visit opts) stmts

instance Visit (Statement a) where
  visit opts f@Fun{..} =
    f { fun_name = visitOpts fun_name
      , fun_args = visitOpts fun_args
      , fun_result_annotation = Nothing
      , fun_body = visitOpts fun_body
      , stmt_annot = stmt_annot
      }
    where
      visitOpts :: (Visit a) => a -> a
      visitOpts = visit opts
  visit _ a = a

instance Visit (Ident a)

instance Visit (Parameter a) where
  visit _ a@Param{..} = a{param_py_annotation=Nothing}
  visit _ a@VarArgsPos{..} = a{param_py_annotation=Nothing}
  visit _ a@VarArgsKeyword{..} = a{param_py_annotation=Nothing}
  visit _ x = x
