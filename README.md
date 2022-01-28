# cluco
### _Yago Teixeira_

This is an attempt to translate Clojure`s Hiccup lib to CL: https://github.com/weavejester/hiccup.

## Usage

Basic usage:

```lisp

CL-USER> (in-package #:cluco)

CLUCO> (html #(:div #(:h1 "Hello, World")))

"<div> <h1> Hello, World </h1> </div>"

```

## License

GPL 3
