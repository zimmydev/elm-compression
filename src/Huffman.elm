module Huffman exposing (encode)

import Bytes exposing (Bytes)
import Huffman.CodeTable exposing (CodeTable)


encode : Bytes -> CodeTable -> Bytes
encode bytes codeTable =
    Debug.todo "Huffman encoding"
