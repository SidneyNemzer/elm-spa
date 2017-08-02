module Page.NotFound exposing (..)

import UrlParser as Url
import Html
import Route


main_ : Route.Page String model msg
main_ =
    { parser = Url.string
    , title = "Not Found"
    , model = identity
    , init = \flags -> {} ! []
    , update = \_ _ -> {} ! []
    , subscriptions = \_ -> Sub.none
    , view = \_ -> Html.text "Not Found"
    }


type alias Model =
    {}
