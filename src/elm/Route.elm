module Route exposing (..)

import Dict exposing (Dict)
import Task exposing (Task)
import Html exposing (Html, div, text)
import UrlParser exposing (Parser, s)
import Navigation exposing (Location)
import List.Extra as List


type Routes
    = Home
    | NotFound



-- UPDATE --


type Msg subMsg
    = SubMsg String subMsg
    | ChangeLocation Location


update : Msg subMsg -> Config flags subModel subMsg -> ( Config flags subModel subMsg, Cmd (Msg subMsg) )
update msg config =
    case msg of
        ChangeLocation newLocation ->
            let
                ( route, page, flags ) =
                    pageFromLocation config newLocation

                ( newModel, newCmd ) =
                    page.init flags

                updatedPage =
                    { page
                        | model = newModel
                    }
            in
                ( { config
                    | currentPage =
                        route
                    , routes =
                        Dict.insert
                            route
                            updatedPage
                            config.routes
                  }
                , Cmd.map (SubMsg route) newCmd
                )

        SubMsg route subMsg ->
            case Dict.get route config.routes of
                Just page ->
                    let
                        ( newModel, newCmd ) =
                            page.update subMsg page.model
                    in
                        ( { config
                            | routes =
                                Dict.insert route { page | model = newModel } config.routes
                          }
                        , Cmd.map (SubMsg route) newCmd
                        )

                Nothing ->
                    Debug.log "Got a messege for a missing route" route
                        |> (\_ -> config ! [])


maybeToBool : Maybe a -> Bool
maybeToBool maybe =
    case maybe of
        Just _ ->
            True

        Nothing ->
            False


pageFromLocation : Config flags subModel subMsg -> Location -> ( String, Page flags subModel subMsg, Maybe flags )
pageFromLocation config location =
    let
        runParser =
            case config.historyType of
                Hash ->
                    UrlParser.parseHash

        notFound =
            ( location.hash, config.notFound, Nothing )
    in
        if String.isEmpty location.hash then
            ( "", config.home, Nothing )
        else
            Dict.toList config.routes
                |> List.find
                    (\( route, page ) ->
                        runParser page.parser location
                            |> maybeToBool
                    )
                |> (\result ->
                        case result of
                            Just ( route, page ) ->
                                ( route
                                , page
                                , runParser page.parser location
                                )

                            Nothing ->
                                notFound
                   )



-- SUBSCRIPTIONS --


subscriptions : Config flags subModel subMsg -> Sub (Msg subMsg)
subscriptions config =
    Dict.toList config.routes
        |> List.map
            (\( route, page ) ->
                page.subscriptions page.model
                    |> Sub.map (SubMsg route)
            )
        |> Sub.batch



-- VIEW --
--
-- view : Config a flags subModel subMsg -> Html (Msg subMsg)
-- view config =
