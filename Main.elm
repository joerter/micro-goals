import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Time exposing (..)

main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type alias Model =
    { nextGoal : String
    , nextTime : Time
    , currentGoal : String
    , currentTime : Time
    }

initialModel : Model
initialModel =
    Model "" (inSeconds 0) "" (inSeconds 0)

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

type Msg
    = NextGoalInput String
    | NextTimeInput String
    | Start
    | Tick Time

toTimeOrDefault : String -> Time -> Time
toTimeOrDefault string default =
    String.toFloat string |> Result.toMaybe |> Maybe.withDefault default |> inSeconds

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NextGoalInput nextGoal ->
            ({ model | nextGoal = nextGoal }, Cmd.none)
        NextTimeInput nextTime ->
            ({ model | nextTime = toTimeOrDefault nextTime 0 }, Cmd.none)
        Start ->
            ({ model | currentGoal = model.nextGoal, currentTime = model.nextTime }, Cmd.none)
        Tick newTime ->
            ({ model | currentTime = model.currentTime - 1}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick

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
