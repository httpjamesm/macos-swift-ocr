# macos-swift-ocr-rust-ffi

This is an example of a library built for OCR using the macOS Vision API available in 15.0 and higher. It is targeted towards FFI usage in Rust using [swift-rs](https://github.com/Brendonovich/swift-rs/).

## Try it out

1. Run `swift build` in your Terminal.
2. Run `swift run ocr` appended with the path of your image.
3. It will return the text contents of the image in English using the fast engine.

## Usage in Rust

1. Include the package in your Rust program's source directory.
Using a git submodule is a great and easy way.
2. Link the package in your Rust program's build file.

```rust
#[cfg(target_os = "macos")]
{
    println!("cargo:rerun-if-changed=swift-libs/text-recognition/Sources/");
    println!("cargo:rerun-if-changed=swift-libs/text-recognition/Package.swift");
    println!("cargo:rerun-if-changed=swift-libs/text-recognition/Resources/");
    println!("cargo:rerun-if-changed=build.rs");

    SwiftLinker::new("10.15")
        .with_package("TextRecognition", "./swift-libs/text-recognition/")
        .link();
}
```

3. Use the `swift!` macro to define the function signature.

```rust
swift!(fn recognize_text(path: &SRString) -> SRString);
```

4. Use it to recognize text in Rust.
```rust
unsafe {
    let result = recognize_text(&path);
    return Ok(result.to_string());
}
```
