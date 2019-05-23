module Compression exposing (Size, Symbol, Weight, decodeBytesAsArray)

import Array exposing (Array)
import Bytes exposing (Bytes)
import Bytes.Decode as BDecode exposing (Decoder, Step(..))


{-| A `Symbol` represents a discrete byte in the stream you want to compress. The string `"ABBC"` contains the unique symbols `'A'`, `'B'`, and `'C'`. It can also be thought of as an unsigned integer in the range [0,255].

Symbols should really only be used in a read-only fashion. If you do wish to modify a symbol for some reason, just note that when a `Symbol` is being encoded into `Bytes` using this library, the overflow bits will be truncated, effectively storing it _modulo-256_. This follows the behaviour of the `Bytes.Encode` library.

-}
type alias Symbol =
    Int


{-| `Weight`, in the context of compression, is the number of times that some `Symbol` appears in a stream that you want to compress. It could have also been called `Count`.
-}
type alias Weight =
    Int


{-| `Size` is a generic type that represents some positive-integer measure of size (a.k.a. width). It is just an alias for `Int`. Depending on how it is used in the library, it could represent a size in bits or bytes.
-}
type alias Size =
    Int



--- COMMONLY-USED FUNCTIONALITY ---


{-| Decodes a series of bytes as a list of symbols.
-}
decodeBytesAsArray : Bytes -> Array Symbol
decodeBytesAsArray bytes =
    let
        size =
            Bytes.width bytes
    in
    BDecode.decode (unsignedInt8ListDecoder size) bytes
        -- Due to our particular decoder never failing, we can safely default.
        |> Maybe.withDefault Array.empty



--- HELPER FUNCTIONS ---


unsignedInt8ListDecoder : Int -> Decoder (Array Symbol)
unsignedInt8ListDecoder size =
    BDecode.loop ( 0, Array.initialize size (always 0) )
        (\( n, acc ) ->
            if n >= size then
                BDecode.succeed (Done acc)

            else
                BDecode.unsignedInt8
                    |> BDecode.map (\x -> Loop ( n + 1, acc |> Array.set n x ))
        )
