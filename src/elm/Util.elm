module Util exposing (..)

import Task exposing (Task)
import Firebase
import Firebase.Database as Database
import Firebase.Database.Types exposing (Database, Snapshot, Reference)
import Firebase.Database.Snapshot as Snapshot
import Json.Decode as Decode exposing (Decoder)
import Task exposing (Task)
import Dict exposing (Dict)


{-| Ensure firebase is loaded and provide it when needed
-}
database : Database
database =
    Database.init
        (case Firebase.app () of
            Just app ->
                app

            Nothing ->
                Debug.crash "Failed to load Firebase"
        )


decodeSnapshot : Decoder a -> Snapshot -> Result String a
decodeSnapshot decoder snapshot =
    Snapshot.exportVal snapshot
        |> Decode.decodeValue decoder


{-| Similar to Json.Decode.keyValuePairs, but this returns a Dict instead of
a list
-}
keyValueDecoder : Decoder a -> Decoder (Dict String a)
keyValueDecoder valueDecoder =
    Decode.keyValuePairs valueDecoder
        |> Decode.andThen
            (Dict.fromList >> Decode.succeed)


resultToTask : Result x a -> Task x a
resultToTask result =
    case result of
        Ok a ->
            Task.succeed a

        Err x ->
            Task.fail x


{-| When you just care about the message, not the value
-}
sneakyLog : String -> a -> a
sneakyLog message passthrough =
    Debug.log "Log" message
        |> (\_ -> passthrough)
