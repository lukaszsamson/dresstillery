module BasketItem exposing (..)

import ProductModels exposing (..)


type BasketItem
    = CatalogItem { item : ProductsItem, lenght : Lenght }
    | CustomItem { color : String, lenght : Lenght }
