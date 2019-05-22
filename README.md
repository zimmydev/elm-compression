# elm-compression [![Build Status](https://travis-ci.com/zimmydev/elm-compression.svg?branch=master)](https://travis-ci.com/zimmydev/elm-compression)

*NOTE: This library is under development. It is mostly unusable in its current form.*

An aspiring general-purpose compression library written for Elm.

This package will not include every compression method; rather, it will includes implementations of common coding and compression schemes. These will be designed like building blocks, so that composing them into more complex schemes should be easy and relatively straight-forward (that's the hope, at least).

Any gaps in the library be made as easy as possible to fill using the library itself, in most cases. A high-level API (e.g. compressing `Bytes` to a `gzip` file) should be available, but so should a low-level API and that allows access to the transform and coding layers. This should allow you to create new or unincluded compression schemes in (usually) just a few lines of code.

## Roadmap for this library

*NOTE: This is more a checklist for myself than anything else.*

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