module Main where

import Prelude

import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)
import Data.Int (fromString)
import Data.Maybe (fromMaybe)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

data Action = Increment Int
            | Decrement Int
            | Grid1
            | Grid3
            | Grid5
            | SetPage Int
            | Zoom Int

type State l = { page :: Int
               , grid :: Int
               | l
               }

component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }
  where
  initialState _ = { page: 1
                   , grid: 3
                   }

  grid { grid: 1, page: p } = [ pageImage (p) ]
  grid { grid: 3, page: p } = [ pageImage (p - 1)
                              , pageImage (p)
                              , pageImage (p + 1)
                              ]
  grid { grid: 5, page: p } = [ pageImage (p - 2)
                              , pageImage (p - 1)
                              , pageImage (p)
                              , pageImage (p + 1)
                              , pageImage (p + 2)
                              ]
  grid _ = []
          
  pageImage n = HH.img [ HP.src ("/book/" <> show n)
                       , HP.class_ $ H.ClassName $ "page"
                       , HP.id_ $ "page" <> (show n)
                       , HE.onDoubleClick \_ -> Zoom n
                       , HE.onClick \_ -> SetPage n
                       ]
  pageControl state = HH.div
    [ HP.class_ $ H.ClassName $ "controls" ]
    [ HH.button [ HE.onClick \_ -> Decrement 10 ] [ HH.text "<<" ]
    , HH.button [ HE.onClick \_ -> Decrement 1 ] [ HH.text "<" ]
    , HH.input  [ HP.value $ show state.page
                , HE.onValueChange \v -> SetPage $ fromMaybe state.page (fromString v)
                ]
    , HH.button [ HE.onClick \_ -> Increment 1 ] [ HH.text ">" ]
    , HH.button [ HE.onClick \_ -> Increment 10 ] [ HH.text ">>" ]
    ]

  gridControl state = HH.div
    [ HP.class_ $ H.ClassName $ "controls" ]
    [ HH.button [ HE.onClick \_ -> Grid1 ] [ HH.text "1" ]
    , HH.button [ HE.onClick \_ -> Grid3 ] [ HH.text "3" ]
    , HH.button [ HE.onClick \_ -> Grid5 ] [ HH.text "5" ]
    ]

  render state =
    HH.div_
      [ HH.div [ HP.class_ $ H.ClassName $ "grid" ] (grid state)
      , pageControl state
      , gridControl state
      ]

  handleAction = case _ of
    Increment n -> H.modify_ \state -> state { page = state.page + n }
    Decrement n -> H.modify_ \state -> if (state.page - n) > 1 then (state {page = (state.page - n)}) else state
    SetPage n -> H.modify_ \state -> state {page = n}
    Grid1 -> H.modify_ \state -> state { grid = 1 }
    Grid3 -> H.modify_ \state -> state { grid = 3 }
    Grid5 -> H.modify_ \state -> state { grid = 5 }
    Zoom p -> H.modify_ \state -> state { page = p, grid = 1 }

