module Compression.Bits.Reader exposing (Reader, advance, init, read, readOne)

import Array exposing (Array)
import Bitwise
import Bytes exposing (Bytes)
import Compression exposing (..)
import Compression.Bits as Bits exposing (Bit, Bits)
import Maybe.Extra exposing (combine)


{-| A `Reader` reads bits from a byte. It's stateful, so you can read a bit or multiple bits at a time, while also being able to arbitrarily move the "head" of the `Reader`. The API has been designed to make decoding a byte-stream at the bit-level fairly straightforward.
-}
type Reader
    = Reader Internals


type alias Internals =
    { byteArray : Array Int

    -- The position in terms of bits, not bytes
    , position : Int
    }



--- OBTAINING A BIT-READER ---


init : Bytes -> Reader
init bytes =
    Reader
        { byteArray = decodeBytesAsArray bytes
        , position = 0
        }



--- READING FROM A BIT-READER ---


readOne : Reader -> Maybe Bit
readOne reader =
    readHelper 0 reader


read : Int -> Reader -> Maybe Bits
read count reader =
    List.range 0 (count - 1)
        |> List.map (\o -> readHelper o reader)
        |> combine
        |> Maybe.map Bits.fromList



--- MOVING AROUND THE READER-HEAD --


advance : Int -> Reader -> Reader
advance delta (Reader reader) =
    Reader { reader | position = reader.position + delta }



--- HELPER FUNCTIONS ---


readHelper : Int -> Reader -> Maybe Int
readHelper offset (Reader { byteArray, position }) =
    byteArray
        |> getBit (position + offset)


getBit : Int -> Array Int -> Maybe Bit
getBit bitNumber byteArray =
    byteArray
        -- Get the byte
        |> Array.get (bitNumber // 8)
        -- And then maybe get the bit of the byte, if that byte existed
        |> Maybe.andThen (getBitInByte (modBy 8 bitNumber))


getBitInByte : Int -> Int -> Maybe Bit
getBitInByte bitNumber byte =
    let
        shiftAmount =
            -- The amount we'll need to shift to do our bit-reading logic
            7 - bitNumber

        mask =
            1 |> Bitwise.shiftLeftBy shiftAmount
    in
    if bitNumber > 0 && bitNumber <= 7 then
        byte
            |> Bitwise.and mask
            |> Bitwise.shiftRightZfBy shiftAmount
            |> Just

    else
        Nothing
