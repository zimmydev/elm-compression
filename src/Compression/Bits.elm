module Compression.Bits exposing (Bit, Bits, append, concat, empty, fromBytes, fromList, size, toBytes, toList)

import Bytes exposing (Bytes)


type alias Bit =
    Int


type
    Bits
    -- Bits are ordered with the LSB as the head of the list, which is just
    -- an implementation detail to save CPU for `append` operations.
    = Bits (List Int)



--- OBTAINING BITS ---


empty : Bits
empty =
    Bits []



--- TRANSFORMING BITS ---


append : Bit -> Bits -> Bits
append bit (Bits bits) =
    Bits (clamp 0 1 bit :: bits)


concat : Bits -> Bits -> Bits
concat (Bits bits2) (Bits bits1) =
    Bits (bits2 ++ bits1)



--- ACCESSING PROPERTIES OF BITS ---


size : Bits -> Int
size (Bits bits) =
    List.length bits



--- CONVERTING BITS ---


fromBytes : Bytes -> Bits
fromBytes bytes =
    Debug.todo "Convert bytes to bits"


toBytes : Bits -> Bytes
toBytes bits =
    Debug.todo "Convert bits to bytes"


toList : Bits -> List Bit
toList (Bits bits) =
    List.reverse bits


fromList : List Bit -> Bits
fromList list =
    List.reverse list
        |> Bits
