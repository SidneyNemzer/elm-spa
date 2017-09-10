module Page.NotFound exposing (..)

import Html
import Route


main_ : Route.SimplePage msg
main_ =
    { title = "Not Found"
    , view = Html.text "Not Found"
    }
