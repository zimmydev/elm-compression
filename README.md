# elm-compression [![Build Status](https://travis-ci.com/zimmydev/elm-compression.svg?branch=master)](https://travis-ci.com/zimmydev/elm-compression)

NOTE: This library is under development. It is mostly unusable in its current form.

A general-purpose compression library written in (and written for) Elm. This package does not include every compression method; rather, it includes implementations of common coding and compression schemes. These schemes are written modularly in a such a way that composing them into more complex schemes is easy and relatively straight-forward (that's the hope, at least).

Any gaps in the library have been made as easy as possible to fill using the library itself, in most cases. High-level functions that compress bytes to a `gzip` file are available, but so are low-level functions and data structures that work on the coding and transform layers. This allows you to create new or unincluded compression schemes in (usually) just a few lines of code.

## Roadmap for this library

**NOTE: This is more a checklist for myself than anything else.**

### Planned

* Elaborate this README
* Huffman Coding
  * ~~Infrastructure~~
  * Encoding
  * Decoding
* Arithmetic Coding
  * Infrastructure
  * Encoding
  * Decoding
* ANS Coding
  * Infrastructure
  * Compression
  * Decompression
* RLE Compression
  * Infrastructure
  * Compression
  * Decompression
* LZ77 Compression
  * Infrastructure
  * Compression
  * Decompression
* LZ78 Compression
  * Infrastructure
  * Compression
  * Decompression
* DEFLATE
  * Compression
  * Decompression
* gzip
* more…

### Maybe?

* Adaptive versions of some coders
* FSE Coding