module Page.Home exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, h2, p, text)
import Html.Attributes exposing (class)
import Dict exposing (Dict)
import Task exposing (Task)
import Data.Post as Post exposing (Post)
import Request.Post


type alias Model =
    { posts : Dict String Post
    }


init : Task String Model
init =
    Task.map
        Model
        Request.Post.list



-- UPDATE --


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []



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
