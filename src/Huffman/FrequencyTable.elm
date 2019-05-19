module Huffman.FrequencyTable exposing (FrequencyTable, bytesFromString, countTable)

import Bytes exposing (Bytes, Endianness(..))
import Bytes.Decode as BDecode exposing (Decoder, Step(..))
import Bytes.Encode as BEncode exposing (Encoder)
import Dict exposing (Dict)



--- TYPES ---


type FrequencyTable
    = FrequencyTable (Dict Int Float)



--- TYPES FOR INTERNAL USE ---


type alias CountTable =
    Dict Int Int



--- OBTAINING A FREQUENCY-TABLE ---


load : Bytes -> FrequencyTable
load bytes =
    Debug.todo "load bytes"


loadString : String -> FrequencyTable
loadString string =
    Debug.todo "load a string"



--- GENERATING A SYMBOL COUNT-TABLE ---


countTable : Bytes -> CountTable
countTable bytes =
    let
        size =
            Bytes.width bytes

        startOrIncrement maybeCount =
            case maybeCount of
                Nothing ->
                    Just 1

                Just count ->
                    Just (count + 1)
    in
    case BDecode.decode (unsignedInt8List size) bytes of
        Nothing ->
            Dict.empty

        Just symbols ->
            symbols
                |> List.foldl
                    (\symbol acc -> acc |> Dict.update symbol startOrIncrement)
                    Dict.empty


unsignedInt8List : Int -> Decoder (List Int)
unsignedInt8List size =
    BDecode.loop ( size, [] )
        (\( n, acc ) ->
            if n <= 0 then
                BDecode.succeed (Done (List.reverse acc))

            else
                BDecode.map (\x -> Loop ( n - 1, x :: acc )) BDecode.unsignedInt8
        )


bytesFromString : String -> Bytes
bytesFromString string =
    BEncode.encode (BEncode.string string)
