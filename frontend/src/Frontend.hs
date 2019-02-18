{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE FlexibleContexts    #-}

module Frontend where

import qualified Data.Text as T
import Reflex.Dom.Core
--import Questions

import           Language.Javascript.JSaddle.Types  (liftJSM, JSString, JSVal, JSM, MonadJSM)

import           Language.Javascript.JSaddle        (jss, js0, js1, js2,  jsg, create,


                                                     setProp, textToJSString, toJSVal, js,
                                                     toJSString, getProp, obj, fun)


import Data.Maybe
import Reflex.Dom
import Control.Monad.Reader
import Data.Map as Map

import Reflex.Dom.Routing.Writer
import Reflex.Dom.Routing.Nested

import Reflex.Dom.SemanticUI as SUI

frontend ::  (StaticWidget x (),  Widget x ())
frontend = (head', body)
  where
    head' = do
      el "title" $ text "Gym App"
      styleSheet "styling.css"
      styleSheet "semantic.min.css"
      styleSheet "vis.min.css"
      styleSheet "extra.css"

      where
        styleSheet linkvar = elAttr "link" (Map.fromList [
                                              ("rel","stylesheet")
                                            , ("type", "text/css")
                                            , ("href", linkvar)
                                            ]) $ return ()
    body = runRouteWithPathInFragment $
          fmap snd $ runRouteWriterT $ newBodyWrapper


newBodyWrapper ::  (RouteWriter t T.Text m,
                   HasRoute t T.Text m,
                   MonadWidget t m ) =>  m ()
newBodyWrapper = mdo
  let mainConfig =  def
        & elConfigAttributes |~ ("id" =: "main")
        & elConfigClasses |~ "ui container"
  ui "div" mainConfig $ do
    pageHeader H1 def $ text "Course Weight Tracker "

    res <- input (def & SUI.inputConfig_fluid |~ True
                   ) $
      SUI.textInput $ def & textInputConfig_placeholder |~ "Name"

    blank
