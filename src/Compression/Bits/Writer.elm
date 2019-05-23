module Compression.Bits.Writer exposing (Writer, value, write)

import Compression.Bits as Bits exposing (Bit, Bits)


{-| `Writer` is a thin wrapper over `Bits`. Use this when writing bits. It has the added semantic context of "`Bits` as a write-buffer."
-}
type Writer
    = Writer Bits



--- OBTAINING A BIT-WRITER ---


empty : Writer
empty =
    Writer Bits.empty


init : Bits -> Writer
init bits =
    Writer bits



--- WRITING WITH A BIT-WRITER ---


write : Bit -> Writer -> Writer
write bit (Writer bits) =
    bits
        |> Bits.append bit
        |> Writer



--- OBTAINING WRITTEN BITS ---


value : Writer -> Bits
value (Writer bits) =
    bits
