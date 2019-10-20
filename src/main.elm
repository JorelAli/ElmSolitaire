import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Styled exposing (toUnstyled)
import Dom exposing (..)
import Css exposing (backgroundColor, color, rgb)
import Css.Global exposing (global, everything, selector)
import Dict exposing (Dict)
import Random
import Html5.DragDrop as DragDrop exposing (Position)

-- MAIN

main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL

cardNumbers : Int -> String
cardNumbers num = case num of 
  1 -> "A"
  2 -> "2"
  3 -> "3"
  4 -> "4"
  5 -> "5"
  6 -> "6"
  7 -> "7"
  8 -> "8"
  9 -> "9"
  10 -> "10"
  11 -> "J"
  12 -> "Q"
  13 -> "K"
  _ -> "?"

cardTypes : Int -> String
cardTypes num = case num of
  0 -> "Diamond"
  1 -> "Heart"
  2 -> "Spade"
  3 -> "Club"
  _ -> "??"

type alias Card = {
  numericalValue : Int
  , cardType : Int
  , domElement : Element Msg
  }

-- type R = A Int

-- randomCard : Card
-- randomCard = 
--   let
--     num = Random.generate A (Random.int 1 13)
--     typ = Random.generate A (Random.int 0 3)
--   in {
--     numericalValue = num
--     , cardType = typ
--     , domElement = card (cardNumbers num) (cardTypes typ)
--   } 

type alias Model = {
  data : { a : Int, pos : Position }
  , dragDrop : DragDrop.Model Int Int
  }

init : Model
init = { 
  data = { a = 0, pos = {width = 0, height = 0, x = 0, y = 0}}
  , dragDrop = DragDrop.init
  }


-- UPDATE

type Msg = DragDropMsg (DragDrop.Msg Int Int)

update : Msg -> Model -> Model
update msg model =
  case msg of

  DragDropMsg msg_ ->
    let 
      (model_, result) = DragDrop.update msg_ model.dragDrop
    in
      { model
          | dragDrop = model_
          , data = case result of
            Nothing -> model.data
            Just (dragID, dropID, position) -> { a = 0, pos = position}
          --, ...use result if available...
      }


-- VIEW

globalStyleNode : Html Msg
globalStyleNode = global 
  [ selector "body" [ backgroundColor (rgb 255 255 255 ) ] ] 
  |> toUnstyled

card : String -> String -> Element Msg
card number cardType = element "div"
  |> addClass "card"
  |> addStyle ("background-color", "white")
  |> addStyle ("width", "150px")
  |> addStyle ("height", "250px")
  |> addStyle ("border-style", "solid")

  |> addStyle ("text-align", "center")
  |> addStyle ("vertical-align", "middle")

  |> addStyle ("font-family", "Helvetica")
  |> addStyle ("font-size", "30px")
  |> appendChildList [
    element "p"
    |> appendText number
    , element "p"
    |> appendText cardType
  ]

view : Model -> Html Msg
view model = 
  element "div"
  |> appendNode globalStyleNode
  |> addStyle ("background-color", "lightgreen")
  |> appendText "hi"
  |> appendChildList
    [
      card (cardNumbers 2) (cardTypes 2) |> appendNode (div (DragDrop.draggable DragDropMsg 1) [ text "hi"])
      , card (cardNumbers 3) (cardTypes 3) |> appendNode (div (DragDrop.droppable DragDropMsg 1) [ text "hi"])
    ]
  -- element "div"
  -- |> appendChildList
  --   [ element "button"
  --   |> addAction ("click", Decrement)
  --   |> appendText "-"

  --   , element "div"
  --   |> appendText (String.fromInt model)

  --   , element "button"
  --   |> addAction ("click", Increment)
  --   |> appendText "+"

  --   ]
  |> render 
