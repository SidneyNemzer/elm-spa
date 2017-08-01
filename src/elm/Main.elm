module Main exposing (..)

import Html exposing (Html, div, h1, p, a, text)
import Html.Attributes as Attributes
import Util
import Task
import Page.Home as Home
import Route exposing (Route)
import Navigation exposing (Location)


main : Program Never Model Msg
main =
    Navigation.program
        SetRoute
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }


type Page
    = Blank
    | NotFound
    | Errored
    | Home Home.Model


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { pageState : PageState
    }


init : Location -> ( Model, Cmd Msg )
init location =
    { pageState = Loaded Blank
    }
        ! [ Task.attempt HomeLoaded Home.init ]



-- UPDATE --


type Msg
    = Noop
    | SetRoute Location
    | HomeLoaded (Result String Home.Model)
    | HomeMsg Home.Msg


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updatePage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
                { model | pageState = Loaded (toModel newModel) } ! [ Cmd.map toMsg newCmd ]

        page =
            getPage model.pageState
    in
        case ( msg, page ) of
            ( Noop, _ ) ->
                model ! []

            ( SetRoute location, _ ) ->
                ( { model | pageState = TransitioningFrom (getPage model.pageState) }
                , Util.sneakyLog "Loading home..." <| Task.attempt HomeLoaded Home.init
                )

            ( HomeLoaded (Ok subModel), _ ) ->
                { model | pageState = Util.sneakyLog "Finished loading" (Loaded (Home subModel)) } ! []

            ( HomeLoaded (Err error), _ ) ->
                Debug.log "Failed to load home page" error
                    |> \_ -> model ! []

            ( HomeMsg subMsg, Home subModel ) ->
                updatePage Home HomeMsg Home.update subMsg subModel

            ( HomeMsg _, _ ) ->
                Debug.log "Got a HomeMsg on Blank, NotFound, or Errored" ""
                    |> \_ -> model ! []



-- VIEW --


view : Model -> Html Msg
view model =
    let
        page =
            getPage model.pageState
    in
        case page of
            Home subModel ->
                Home.view subModel
                    |> Html.map HomeMsg

            Blank ->
                div []
                    [ h1 [] [ text "This is a blank page" ]
                    , p [] [ text "The homepage is probably being loaded" ]
                    , a [ Attributes.href "#test" ] [ text "This is a test" ]
                    ]

            _ ->
                Debug.crash "Cannot render anything but homepage"
