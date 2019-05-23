module Compression.Bits.ElmjutsuDumMyM0DuL3 exposing (..)
-- exposing (Writer)

import Compression.Bits as Bits exposing (Bits)


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

write :
