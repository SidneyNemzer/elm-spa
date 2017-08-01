module Request.Post exposing (..)

import Data.Post as Post exposing (Post)
import Task exposing (Task)
import Dict exposing (Dict)
import Util
import Firebase.Database.Types exposing (Snapshot, Reference)
import Firebase.Database as Database
import Firebase.Database.Reference as Reference


ref : Reference
ref =
    Database.ref (Just "/posts/") Util.database


get : String -> Task String Post
get id =
    Reference.child id ref
        |> Reference.once "value"
        |> Task.andThen
            (Util.decodeSnapshot Post.decoder >> Util.resultToTask)


list : Task String (Dict String Post)
list =
    Reference.once "value" ref
        |> Task.andThen
            (Util.decodeSnapshot
                (Util.keyValueDecoder Post.decoder)
                >> Util.resultToTask
            )
