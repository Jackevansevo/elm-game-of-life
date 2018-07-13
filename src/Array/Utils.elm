module Array.Utils exposing (..)

import Array exposing (Array)


last : Array a -> Maybe a
last array =
    Array.get (Array.length array - 1) array


butLast : Array a -> Array a
butLast array =
    Array.slice 0 -1 array


pop : Array a -> ( Array a, Maybe a )
pop array =
    ( butLast array, last array )


any : (a -> Bool) -> Array a -> Bool
any fn array =
    not (Array.isEmpty (Array.filter fn array))


reverseArray : Array a -> Array a
reverseArray array =
    Array.fromList (List.reverse (Array.toList array))
