import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

main : Program Never Model Msg
main =
    Html.beginnerProgram {model = model, view = view, update = update}

type alias Model =
    { nextGoal : String
    , nextTime : Int
    , currentGoal : String
    , currentTime : Int
    }

model : Model
model =
    Model "" 0 "" 0

type Msg
    = Goal String
    | Time String
    | Start

toIntOrDefault : String -> Int -> Int
toIntOrDefault string default =
    String.toInt string |> Result.toMaybe |> Maybe.withDefault default

update : Msg -> Model -> Model
update msg model =
    case msg of
        Goal nextGoal ->
            { model | nextGoal = nextGoal }
        Time nextTime ->
            { model | nextTime = toIntOrDefault nextTime 0 }
        Start ->
            { model | currentGoal = model.nextGoal, currentTime = model.nextTime }

view : Model -> Html Msg
view model =
    div []
        [
            input [ type_ "text", placeholder "Get stuff done", onInput Goal] []
            , input [ type_ "number", onInput Time] []
            , button [ onClick Start] [ text "Do It!"]
            , div []
                [
                    h1 [] [ text model.currentGoal ]
                    , h2 [] [ text (toString model.currentTime) ]
                ]
        ]
