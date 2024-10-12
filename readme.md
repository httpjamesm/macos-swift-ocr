# macos-swift-ocr-rust-ffi

This is an example of a library built for OCR using the macOS Vision API available in 15.0 and higher. It is targeted towards FFI usage in Rust using swift-rs.

## Try it out

1. Run `swift build` in your Terminal.
2. Run `swift run ocr` appended with the path of your image.
3. It will return the text contents of the image in English using the fast engine.
