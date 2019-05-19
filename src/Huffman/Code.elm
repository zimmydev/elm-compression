module Huffman.Code exposing (Bit(..), Code, append, empty, toList)

import Huffman.Types exposing (..)


type Bit
    = Zero
    | One


type Code
    = Code (List Int)



--- OBTAINING A CODE ---


empty : Code
empty =
    Code []


append : Bit -> Code -> Code
append bit (Code bits) =
    Code (toInt bit :: bits)



--- TRANSFORMING A CODE ---


toList : Code -> List Int
toList (Code bits) =
    List.reverse bits



--- HELPER FUNCTIONS --


toInt : Bit -> Int
toInt bit =
    case bit of
        Zero ->
            0

        One ->
            1
