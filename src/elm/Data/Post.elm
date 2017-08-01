module Data.Post exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode exposing ((|:))


type alias Post =
    { title : String
    , body : String
    }


decoder : Decoder Post
decoder =
    Decode.succeed (Post)
        |: Decode.field "title" Decode.string
        |: Decode.field "body" Decode.string
