import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Time exposing (..)

-- time is always in minutes because the tasks shouldn't
-- be longer than 60 minutes
main : Program Never Model Msg
main =
    Html.beginnerProgram {model = model, view = view, update = update}

type alias Model =
    { nextGoal : String
    , nextTime : Time
    , currentGoal : String
    , currentTime : Time
    }

model : Model
model =
    Model "" (inSeconds 0) "" (inSeconds 0)

type Msg
    = NextGoalInput String
    | NextTimeInput String
    | Start

toTimeOrDefault : String -> Time -> Time
toTimeOrDefault string default =
    String.toFloat string |> Result.toMaybe |> Maybe.withDefault default |> inSeconds

update : Msg -> Model -> Model
update msg model =
    case msg of
        NextGoalInput nextGoal ->
            { model | nextGoal = nextGoal }
        NextTimeInput nextTime ->
            { model | nextTime = toTimeOrDefault nextTime 0 }
        Start ->
            { model | currentGoal = model.nextGoal, currentTime = model.nextTime }


view : Model -> Html Msg
view model =
    div []
        [
            input [ type_ "text", placeholder "Get stuff done", onInput NextGoalInput] []
            , input [ type_ "number", onInput NextTimeInput] []
            , button [ onClick Start] [ text "Do It!"]
            , div []
                [
                    h1 [] [ text model.currentGoal ]
                    , h2 [] [ text (toString model.currentTime) ]
                ]
        ]
