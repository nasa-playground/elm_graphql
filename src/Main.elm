module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Data.Contriview exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D exposing (Decoder)
import Json.Encode as E



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( { input = "", status = Init }, Cmd.none )



---- MODEL ----


type alias Model =
    { input : String
    , status : Status
    }


type Status
    = Init
    | Waitting
    | Loaded Contriview
    | Failed Http.Error



---- UPDATE ----


type Msg
    = Input String
    | Send
    | Receive (Result Http.Error Contriview)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input newInput ->
            ( { model | input = newInput }, Cmd.none )

        Send ->
            ( { model | input = "", status = Waitting }
            , Http.post
                { url = "http://127.0.0.1:8080/graphql"
                , body = Http.jsonBody (testJson model.input)
                , expect = Http.expectJson Receive contriviewDecoder
                }
            )

        Receive (Ok contriview) ->
            ( { model | status = Loaded contriview }, Cmd.none )

        Receive (Err e) ->
            ( { model | status = Failed e }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit Send ]
            [ input
                [ onInput Input
                , autofocus True
                , placeholder "GitHub username"
                , value model.input
                ]
                []
            , button [ disabled (model.status == Waitting) ] [ text "submit" ]
            ]
        , case model.status of
            Init ->
                text ""

            Waitting ->
                text "Waitting..."

            Loaded contriview ->
                text (String.fromInt contriview.sum)

            Failed error ->
                text (Debug.toString error)
        ]


testJson : String -> E.Value
testJson s =
    E.object
        [ ( "query", E.string ("query { contriview(username: \"" ++ s ++ "\") { sumContributions }}") )
        ]
