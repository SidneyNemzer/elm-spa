module Pages exposing (..)

import Route exposing (SimplePage, DynamicPage)
import Page.NotFound as NotFound
import Page.Home as Home


type Pages flags model msg
    = NotFound (SimplePage msg)
    | Home (DynamicPage flags model msg)


type PageModel
    = HomeModel Home.Model
