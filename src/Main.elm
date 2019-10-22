module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Styled exposing (toUnstyled)
import Dom exposing (..)
import Css exposing (..)
import Css.Global exposing (global, selector, class)
import Dict exposing (Dict)
import Random
import Html5.DragDrop as DragDrop exposing (Position)


-- MAIN

main =
  Browser.sandbox { init = init, update = update, view = view }


-- MAGIC NUMBERS

cardWidth = 170
cardHeight = cardWidth * 1.4

cardOverlay = "-230px"


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

allCards__ : Int -> List (Element Msg)
allCards__ j = allCards 13 j

allCards : Int -> Int -> List (Element Msg)
allCards i j = if i == 0 then []
  else (card (cardNumbers i) (cardTypes j)) :: allCards (i - 1) j --card (cardNumbers 1) (cardTypes 1)

allCards_ j = if j == 4 then []
  else allCards__ j ++ allCards_ (j + 1)

allCards___ = allCards_ 0

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
  [ 
    selector "body" [ backgroundImage (url "bg.jpg") ]
    , class "card" [
      backgroundColor (hex "#ffffff")
      , Css.width (px cardWidth)
      , Css.height (px cardHeight)
      , borderStyle solid
      , borderRadius (px 30)
      , verticalAlign middle
      , fontFamilies ["Helvetica"]
      , fontSize (px 20)
      , float left
      , marginRight (px 10)
      , marginBottom (px 10)
      , padding (px 10)
      , position relative
    ]
  ] 
  |> toUnstyled

card : String -> String -> Element Msg
card number cardType = element "div"
  |> addClass "card"
  |> appendChildList [
      element "p" 
        |> appendText (number ++ "\n") 
        |> addStyle ("margin", "0")
        |> addStyle ("font-weight", "bold")
    , element "span"
        |> appendChild (element "img" 
          |> addAttributeList [ 
            (src (cardType ++ ".png"))
            , (draggable "false") 
            ] 
          |> addStyleList [ 
            ("max-width", "100%"), 
            ("max-height", "100%")
            ]
          )
    , element "p" 
        |> appendText number 
        |> addStyleList [ 
            ("position", "absolute")
          , ("bottom", "10px")
          , ("right", "10px")
          , ("margin", "0") 
          , ("font-weight", "bold")
        ]
  ]

renderPiles : Int -> Bool -> List (Element Msg)
renderPiles amount first = 
  if amount == 1
  then [card (cardNumbers 1) (cardTypes 1) 
    |> addAttributeList (DragDrop.draggable DragDropMsg 1) 
    |> addStyle ("clear", "both") 
    |> addStyleConditional ("margin-top", cardOverlay) first]
  else renderPiles (amount - 1) first ++ [card (cardNumbers 1) (cardTypes 1) 
    |> addAttributeList (DragDrop.draggable DragDropMsg 1) 
    |> addStyleConditional ("margin-top", cardOverlay) first] 

renderAllPiles = 
  let
    renderAllPiles_ num =
      if num == 0 
      then []
      else (renderPiles num (num /= 7)) ++ renderAllPiles_ (num - 1)
  in renderAllPiles_ 7

view : Model -> Html Msg
view model = 
  element "div"
  
  |> appendNode globalStyleNode
  |> appendChildList
    [
        card (cardNumbers 1) (cardTypes 0) |> addAttributeList ((DragDrop.draggable DragDropMsg 1) ++ (DragDrop.droppable DragDropMsg 1))
      , card (cardNumbers 1) (cardTypes 1) |> addAttributeList ((DragDrop.draggable DragDropMsg 1) ++ (DragDrop.droppable DragDropMsg 1))
      , card (cardNumbers 1) (cardTypes 2) |> addAttributeList ((DragDrop.draggable DragDropMsg 1) ++ (DragDrop.droppable DragDropMsg 1))
      , card (cardNumbers 1) (cardTypes 3) |> addAttributeList ((DragDrop.draggable DragDropMsg 1) ++ (DragDrop.droppable DragDropMsg 1))
    ]
  |> appendChildList
    [
          card "" "heart" |> addStyle ("opacity", "0")
        , card "" "heart" |> addStyle ("opacity", "0")
    ]
  |> appendChild (card (cardNumbers 2) (cardTypes 2) |> addAttributeList (DragDrop.draggable DragDropMsg 1))
  |> appendChildList renderAllPiles
  -- |> appendChild (element "p" |> appendText (String.fromInt (List.length <| allCards_ 0)))
  |> render 
