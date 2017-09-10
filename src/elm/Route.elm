module Route exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Navigation exposing (Location)


-- MODEL --


type alias SimplePage msg =
    { title : String
    , view : Html msg
    }


type alias DynamicPage flags model msg =
    { title : String
    , init : Maybe flags -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    , model : Maybe model
    }


type Page flags model msg
    = Simple (SimplePage msg)
    | Dynamic (DynamicPage flags model msg)


type HistoryType
    = Hash



-- | PushState


type alias Config flags subModel subMsg =
    { pages : Dict String (Page flags subModel subMsg)
    , historyType : HistoryType
    , currentPage : String
    }


maybeDynamicPage : Page flags model msg -> Maybe (DynamicPage flags model msg)
maybeDynamicPage page =
    case page of
        Dynamic dynamicPage ->
            Just dynamicPage

        Simple _ ->
            Nothing



-- UPDATE --


type PageUpdate subMsg
    = PageUpdate String subMsg


updatePage : PageUpdate subMsg -> Config flags subModel subMsg -> ( Config flags subModel subMsg, Cmd (PageUpdate subMsg) )
updatePage msg config =
    case msg of
        PageUpdate route subMsg ->
            let
                maybePage =
                    Dict.get route config.pages
                        |> Maybe.andThen maybeDynamicPage

                maybeModel =
                    Maybe.andThen .model maybePage

                pageUpdate page model =
                    let
                        ( newModel, newCmd ) =
                            page.update subMsg model
                    in
                        ( newModel, Cmd.map (PageUpdate route) newCmd )

                configUpdate :
                    DynamicPage flags subModel subMsg
                    -> ( subModel, Cmd (PageUpdate subMsg) )
                    -> ( Config flags subModel subMsg, Cmd (PageUpdate subMsg) )
                configUpdate page ( newModel, newCmd ) =
                    ( { config
                        | pages =
                            Dict.insert route (Dynamic { page | model = Just newModel }) config.pages
                      }
                    , newCmd
                    )
            in
                Maybe.map2
                    pageUpdate
                    maybePage
                    maybeModel
                    |> Maybe.map2
                        configUpdate
                        maybePage
                    |> Maybe.withDefault
                        (config ! [])


maybeToBool : Maybe a -> Bool
maybeToBool maybe =
    case maybe of
        Just _ ->
            True

        Nothing ->
            False



-- pageFromLocation : Config flags subModel subMsg -> Location -> ( String, Page flags subModel subMsg, Maybe flags )
-- pageFromLocation config location =
--     let
--         runParser =
--             case config.historyType of
--                 Hash ->
--                     UrlParser.parseHash
--
--         notFound =
--             ( location.hash, config.notFound, Nothing )
--     in
--         if String.isEmpty location.hash then
--             ( "", config.home, Nothing )
--         else
--             Dict.toList config.routes
--                 |> List.find
--                     (\( route, page ) ->
--                         runParser page.parser location
--                             |> maybeToBool
--                     )
--                 |> (\result ->
--                         case result of
--                             Just ( route, page ) ->
--                                 ( route
--                                 , page
--                                 , runParser page.parser location
--                                 )
--
--                             Nothing ->
--                                 notFound
--                    )
-- SUBSCRIPTIONS --


subscriptions : Config flags subModel subMsg -> Sub (PageUpdate subMsg)
subscriptions config =
    let
        maybePage =
            Dict.get config.currentPage config.pages
                |> Maybe.andThen maybeDynamicPage

        maybeModel =
            Maybe.andThen .model maybePage

        pageSubs : DynamicPage flags model msg -> model -> Sub (PageUpdate msg)
        pageSubs page model =
            page.subscriptions model
                |> Sub.map (PageUpdate config.currentPage)
    in
        Maybe.map2
            pageSubs
            maybePage
            maybeModel
            |> Maybe.withDefault
                Sub.none



-- VIEW --


viewPage : String -> Page flags model msg -> Maybe (Html (PageUpdate msg))
viewPage currentPage page =
    case page of
        Simple simplePage ->
            Just <| Html.map (PageUpdate currentPage) simplePage.view

        Dynamic dynamicPage ->
            Nothing


view : Config flags subModel subMsg -> Html (PageUpdate subMsg)
view config =
    Dict.get config.currentPage config.pages
        |> Maybe.andThen
            (viewPage config.currentPage)
        |> Maybe.withDefault
            (Html.text ("Failed to render page \"" ++ config.currentPage ++ "\""))



-- let
--     maybePage =
--         Dict.get config.currentPage config.pages
--             |> Maybe.andThen maybeDynamicPage
--
--     maybeModel =
--         Maybe.andThen .model maybePage
--             |> Maybe.withDefault maybePage.
--
--     pageView : { a | view : model -> Html subMsg } -> model -> Html (PageUpdate subMsg)
--     pageView page model =
--         page.view model
--             |> Html.map (PageUpdate config.currentPage)
-- in
--     Maybe.map2
--         pageView
--         maybePage
--         maybeModel
--         |> Maybe.withDefault
--             (Html.text ("Failed to render page \"" ++ config.currentPage ++ "\""))
