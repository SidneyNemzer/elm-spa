module Page.Home exposing (main_, Model)

import Html exposing (Html, div, h2, p, text)
import Html.Attributes exposing (class)
import Dict exposing (Dict)
import Task exposing (Task)
import Data.Post as Post exposing (Post)
import Request.Post
import Route


main_ : Route.DynamicPage flags Model Msg
main_ =
    { title = "Home"
    , init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    , model = Nothing
    }


type alias Model =
    { posts : Dict String Post
    }


init : Maybe flags -> ( Model, Cmd Msg )
init _ =
    ( Model (Dict.fromList [])
    , Task.attempt
        Loaded
        (Task.map
            Model
            Request.Post.list
        )
    )



-- UPDATE --


type Msg
    = Noop
    | Loaded (Result String Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        Loaded (Err err) ->
            model ! []

        Loaded (Ok result) ->
            result ! []



-- VIEW --


viewPosts : Dict String Post -> List (Html Msg)
viewPosts posts =
    Dict.toList posts
        |> List.map
            (\( id, post ) ->
                div [ class "post" ]
                    [ h2 [ class "title" ] [ text post.title ]
                    , p [ class "body" ] [ text post.body ]
                    ]
            )


view : Model -> Html Msg
view model =
    div [ class "posts" ] <|
        viewPosts
            model.posts
