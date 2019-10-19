import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Styled exposing (toUnstyled)
import Dom exposing (..)
import Css exposing (backgroundColor, color, rgb)
import Css.Global exposing (global, everything, selector)
import Dict exposing (Dict)


-- MAIN

main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL

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

type alias Model = Int

init : Model
init = 0


-- UPDATE

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
  Increment ->
    model + 1

  Decrement ->
    model - 1


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
      card (cardNumbers 2) (cardTypes 2)
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
