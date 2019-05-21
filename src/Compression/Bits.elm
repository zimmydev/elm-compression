module Compression.Bits exposing (Bit(..), Bits, append, empty, fromBytes, toBytes, toInts)

import Bytes exposing (Bytes)
import Compression.FrequencyTable exposing (Symbol, Weight)


type Bit
    = Zero
    | One


type Bits
    = Bits (List Int)



--- OBTAINING BITS ---


empty : Bits
empty =
    Bits []



--- TRANSFORMING BITS ---


append : Bit -> Bits -> Bits
append bit (Bits bits) =
    Bits (toInt bit :: bits)



--- CONVERTING BITS ---


fromBytes : Bytes -> Bits
fromBytes bytes =
    Debug.todo "Convert bytes to bits"


toBytes : Bits -> Bytes
toBytes bits =
    Debug.todo "Convert bits to bytes"


toInts : Bits -> List Int
toInts (Bits bits) =
    List.reverse bits



--- HELPER FUNCTIONS --


toInt : Bit -> Int
toInt bit =
    case bit of
        Zero ->
            0

        One ->
            1
