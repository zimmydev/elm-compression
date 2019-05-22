# elm-compression [![Build Status](https://travis-ci.com/zimmydev/elm-compression.svg?branch=master)](https://travis-ci.com/zimmydev/elm-compression)
A general-purpose compression library written in (and written for) Elm. This package does not include every compression method; rather, it includes implementations of common coding and compression schemes. These schemes are written modularly in a such a way that composing them into more complex schemes is easy and relatively straight-forward (that's the hope).

## Roadmap for this library

* Elaborate this README

### Coding

* Huffman coding
  * ~~Infrastructure~~
  * Encoding
  * Decoding
* Arithmetic coding
  * Infrastructure
  * Encoding
  * Decoding

### Dictionary compression

* RLE
  * Infrastructure
  * Encoding
  * Decoding
* LZ77
  * Infrastructure
  * Compression
  * Decompression

### Compression schemes

* DEFLATE
  * Compression
  * Decompression

### Compression filetypes

* gzip
  * Compression
  * Decompression

