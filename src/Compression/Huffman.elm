module Compression.Huffman exposing (decode, encode)

import Bytes exposing (Bytes)
import Compression.FrequencyTable as FrequencyTable
import Compression.Huffman.CodeTable as CodeTable exposing (CodeTable)
import Compression.Huffman.Tree as Tree


encode : Bytes -> Maybe Bytes
encode bytes =
    bytes
        |> codeTable
        |> Maybe.map (encodeWithTable bytes)


decode : Bytes -> Maybe Bytes
decode _ =
    Debug.todo "We'll need to decode the prefixed table and use that to decode the stream; then we'll return the decoded stream"



--- HELPER FUNCTIONS ---


encodeWithTable : Bytes -> CodeTable -> Bytes
encodeWithTable _ _ =
    Debug.todo "We'll need to generate a code-table from the bytes, then use that to encode the bytes"


codeTable : Bytes -> Maybe CodeTable
codeTable bytes =
    bytes
        |> FrequencyTable.generate
        |> Maybe.map Tree.generate
        |> Maybe.map CodeTable.generate
