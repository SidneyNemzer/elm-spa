module Main exposing (..)

import Dict
import Html exposing (Html, div, h1, p, a, text)
import Html.Attributes as Attributes
import Util
import Task
import Pages exposing (PageModel)
import Route
import Navigation exposing (Location)
import Page.NotFound
import Page.Home


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


init : Location -> ( Model flags PageModel subMsg, Cmd (Msg subMsg) )
init location =
    { routeConfig =
        { pages =
            Dict.fromList
                [ ( "not-found", Route.Simple Page.NotFound.main_ )
                , ( "home", Route.Dynamic Page.Home.main_ )
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


update : Msg subMsg -> Model flags model subMsg -> ( Model flags model subMsg, Cmd (Msg subMsg) )
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
                    ! [ Cmd.map PageUpdate newUpdateMsg ]



-- SUBSCRIPTIONS --


subscriptions : Model flags model subMsg -> Sub (Msg subMsg)
subscriptions model =
    Sub.map
        PageUpdate
        (Route.subscriptions model.routeConfig)



-- VIEW --


view : Model flags model subMsg -> Html (Msg subMsg)
view model =
    Html.map
        PageUpdate
        (Route.view model.routeConfig)
