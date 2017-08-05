module Main exposing (..)

import Dict
import Html exposing (Html, div, h1, p, a, text)
import Html.Attributes as Attributes
import Util
import Task
import Pages
import Route
import Navigation exposing (Location)


--main : Program Never (Model flags model (Msg subMsg)) (Msg subMsg)


main =
    Navigation.program
        SetRoute
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model flags model subMsg =
    { routeConfig : Route.Config flags model subMsg
    }


init : Location -> ( Model flags model subMsg, Cmd (Msg subMsg) )
init location =
    { routeConfig =
        { pages =
            Dict.fromList
                [ ( "not-found", Pages.NotFound )
                ]
        , historyType = Route.Hash
        , currentPage = "not-found"
        }
    }
        ! []



-- UPDATE --


type Msg subMsg
    = Noop
    | SetRoute Location
    | PageUpdate (Route.PageUpdate subMsg)



-- update : Msg -> Model flags model subMsg -> ( Model flags model subMsg, Cmd (Msg subMsg) )


update msg model =
    case msg of
        Noop ->
            model ! []

        SetRoute location ->
            model ! []

        PageUpdate updateMsg ->
            let
                ( newConfig, newUpdateMsg ) =
                    Route.updatePage
                        updateMsg
                        model.routeConfig
            in
                { model
                    | routeConfig = newConfig
                }
                    ! [ newUpdateMsg ]



-- SUBSCRIPTIONS --


subscriptions : Model flags model subMsg -> Sub (Route.PageUpdate (Msg subMsg))
subscriptions model =
    Route.subscriptions model.routeConfig



-- VIEW --


view : Model flags model subMsg -> Html (Route.PageUpdate (Msg subMsg))
view model =
    Route.view model.routeConfig
