import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Styled exposing (toUnstyled)
import Dom exposing (..)
import Css exposing (backgroundColor, color, rgb, backgroundImage, url)
import Css.Global exposing (global, everything, selector)
import Dict exposing (Dict)
import Random
import Html5.DragDrop as DragDrop exposing (Position)


-- MAIN

main =
  Browser.sandbox { init = init, update = update, view = view }


-- MAGIC NUMBERS

actualCardWidth = 170
actualCardHeight = actualCardWidth * 1.4

cardHeight = (String.fromFloat actualCardHeight) ++ "px"
cardWidth = (String.fromFloat actualCardWidth) ++ "px"
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

allCards : Int -> List (Element Msg)
allCards i = if i == 0 then []
  else (card (cardNumbers i) (cardTypes 1)) :: allCards (i - 1) --card (cardNumbers 1) (cardTypes 1)

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
  [ selector "body" [ backgroundImage (url "bg.jpg") ] ] 
  |> toUnstyled

card : String -> String -> Element Msg
card number cardType = element "div"
  |> addClass "card"
  |> addStyleList [
      ("background-color", "white")
    , ("width", cardWidth)
    , ("height", cardHeight)
    , ("border-style", "solid")
    , ("border-radius", "30px")
    , ("vertical-align", "middle")
    , ("font-family", "Helvetica")
    , ("font-size", "20px")
    , ("float", "left")
    , ("margin-right", "10px")
    , ("margin-bottom", "10px")
    , ("padding", "10px")
    , ("position", "relative")
  ]
  |> appendChildList [
      element "p" 
        |> appendText (number ++ " " ++ cardType) 
        |> addStyle ("margin", "0")
    , element "p" 
        |> appendText number 
        |> addStyleList [ 
            ("position", "absolute")
          , ("bottom", "10px")
          , ("right", "10px")
          , ("margin", "0") 
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

view : Model -> Html Msg
view model = 
  element "div"
  
  |> appendNode globalStyleNode
  |> appendChildList
    [
      card (cardNumbers 2) (cardTypes 2) |> addAttributeList ((DragDrop.draggable DragDropMsg 1) ++ (DragDrop.droppable DragDropMsg 1))
      , card (cardNumbers 3) (cardTypes 3) |> addAttributeList ((DragDrop.draggable DragDropMsg 1) ++ (DragDrop.droppable DragDropMsg 1))
      , card (cardNumbers 10) (cardTypes 3) |> addAttributeList ((DragDrop.draggable DragDropMsg 1) ++ (DragDrop.droppable DragDropMsg 1))
      , card (cardNumbers 10) (cardTypes 3) |> addAttributeList ((DragDrop.draggable DragDropMsg 1) ++ (DragDrop.droppable DragDropMsg 1))
    ]
  |> appendChildList
    [
      card (cardNumbers 2) (cardTypes 2)  |> addStyle ("opacity", "0")
      , card (cardNumbers 2) (cardTypes 2) |> addStyle ("opacity", "0")
    ]
  |> appendChild (card (cardNumbers 2) (cardTypes 2) |> addAttributeList (DragDrop.draggable DragDropMsg 1))
  |> appendChildList (renderPiles 7 False)
  |> appendChildList (renderPiles 6 True)
  |> appendChildList (renderPiles 5 True)
  |> appendChildList (renderPiles 4 True)
  |> appendChildList (renderPiles 3 True)
  |> appendChildList (renderPiles 2 True)
  |> appendChildList (renderPiles 1 True)
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
