module Compression.Bits exposing (Bit, Bits, append, empty, fromBytes, get, size, sizeInBytes, toBytes)

import Array exposing (Array)
import Bitwise
import Bytes exposing (Bytes)
import Compression exposing (Size)


type Bits
    = Bits Size (Array Int)


type alias Bit =
    Bool



--- OBTAINING BITS ---


empty : Bits
empty =
    Bits 0 (Array.initialize 1 (always 0x00))



--- TRANSFORMING BITS ---


append : Bit -> Bits -> Bits
append bit (Bits sz byteArray) =
    let
        nextSize =
            sz + 1

        pattern =
            bitPattern bit
    in
    if (sz - 1) // 8 < (nextSize - 1) // 8 then
        -- We're crossing a byte boundary
        byteArray
            |> Array.push pattern
            |> Bits (sz + 1)

    else
        let
            ( byteIndex, localIndex ) =
                ( (nextSize - 1) // 8
                , (nextSize - 1) |> modBy 8
                )

            currentByte =
                byteArray
                    |> Array.get byteIndex
                    -- This withDefault branch should never execute
                    |> Maybe.withDefault 0x00

            nextByte =
                currentByte
                    |> Bitwise.or (pattern |> Bitwise.shiftRightZfBy localIndex)
        in
        byteArray
            |> Array.set byteIndex nextByte
            |> Bits (sz + 1)


get : Int -> Bits -> Maybe Bit
get index (Bits sz byteArray) =
    let
        ( byteIndex, localIndex ) =
            ( index // 8
            , index |> modBy 8
            )
    in
    byteArray
        -- Get the byte
        |> Array.get byteIndex
        -- And then maybe get the bit of the byte, if that byte existed
        |> Maybe.map (getBitInByte localIndex)



--- ACCESSING PROPERTIES OF BITS ---


size : Bits -> Size
size (Bits sz _) =
    sz


sizeInBytes : Bits -> Size
sizeInBytes (Bits sz array) =
    if sz == 0 then
        0

    else
        Array.length array



--- CONVERTING BITS ---


fromBytes : Bytes -> Bits
fromBytes bytes =
    Debug.todo "Convert bytes to bits"


toBytes : Bits -> Bytes
toBytes bits =
    Debug.todo "Convert bits to bytes"



--- HELPER FUNCTIONS ---


bitPattern : Bit -> Int
bitPattern bit =
    if bit then
        -- 0b10000000
        0x80

    else
        -- 0b00000000
        0x00


getBitInByte : Int -> Int -> Bit
getBitInByte index byte =
    let
        mask =
            bitPattern True |> Bitwise.shiftRightZfBy index

        bit =
            byte
                |> Bitwise.and mask
                |> Bitwise.shiftLeftBy index
    in
    case bit of
        0x00 ->
            False

        _ ->
            True
