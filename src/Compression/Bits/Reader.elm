module Compression.Bits.Reader exposing (Reader, init, read, readOne, step, stepBy)

import Array exposing (Array)
import Bitwise
import Bytes exposing (Bytes)
import Compression.Bits as Bits exposing (Bit, Bits)
import Maybe.Extra exposing (combine)


{-| A `Reader` reads bits from a byte. It's stateful, so you can read a bit or multiple bits at a time, while also being able to arbitrarily move the "head" of the `Reader`. The API has been designed to make decoding a byte-stream at the bit-level fairly straightforward.
-}
type Reader
    = Reader Int Bits



--- OBTAINING A BIT-READER ---


init : Bits -> Reader
init bits =
    Reader 0 bits



--- READING FROM A BIT-READER ---


readOne : Reader -> Maybe Bit
readOne reader =
    reader
        |> readAtOffset 0


read : Int -> Reader -> Maybe (List Bit)
read count reader =
    List.range 0 (count - 1)
        |> List.map (\o -> reader |> readAtOffset o)
        |> combine



--- MOVING AROUND THE READER-HEAD --


step : Reader -> Reader
step reader =
    reader
        |> stepBy 1


stepBy : Int -> Reader -> Reader
stepBy delta (Reader pos bits) =
    Reader (pos + delta) bits



--- HELPER FUNCTIONS ---


readAtOffset : Int -> Reader -> Maybe Bit
readAtOffset offset (Reader pos bits) =
    bits
        |> Bits.get (pos + offset)
