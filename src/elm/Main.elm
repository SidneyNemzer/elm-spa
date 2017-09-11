module Main exposing (..)

import Html exposing (Html, div, h1, p, a, text)
import Html.Attributes as Attributes
import Util
import Task
import Page.Home as Home
import Route
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


type PageModel
    = HomeModel Home.Model


type PageMsg
    = HomeMsg Home.Msg


type alias Model =
    { currentPage : PageModel
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( model, cmd ) =
            Home.init
    in
        { pageState = HomeModel model
        }
            ! [ Cmd.map HomeMsg cmd ]



-- UPDATE --


type Msg
    = Noop
    | SetRoute Location
    | PageMsg PageMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updatePage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
                { model | pageState = Loaded (toModel newModel) } ! [ Cmd.map toMsg newCmd ]
    in
        case msg of
            Noop ->
                model ! []

            SetRoute location ->
                ( { model | pageState = TransitioningFrom (getPage model.pageState) }
                , Util.sneakyLog "Loading home..." <| Task.attempt HomeLoaded Home.init
                )

            PageMsg page ->
                case page of
                    HomeMsg 



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
