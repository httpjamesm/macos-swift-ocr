//
//  main.swift
//  ocr
//
//  Created by James on 2024-10-12.
//

import Foundation
import Vision
import AppKit

func recognizeText(from imagePath: String) -> String? {
    // Load the image from the specified path
    guard let nsImage = NSImage(contentsOfFile: imagePath),
          let tiffData = nsImage.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiffData),
          let cgImage = bitmap.cgImage else {
        print("Failed to load image from path: \(imagePath)")
        return nil
    }

    // Create a Vision request handler
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    // Variable to hold the recognized text
    var recognizedText = ""

    // Create the text recognition request
    let request = VNRecognizeTextRequest { (request, error) in
        if let error = error {
            print("Text recognition error: \(error.localizedDescription)")
            return
        }

        // Process the results
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            print("No text found")
            return
        }

        // Extract the top candidate strings from each observation
        let strings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }

        // Combine the recognized strings into a single string separated by newlines
        recognizedText = strings.joined(separator: "\n")
    }

    // Configure the request
    request.recognitionLevel = .fast
    request.recognitionLanguages = ["en-US"] // Add more languages if needed
    request.usesLanguageCorrection = true

    // Perform the text recognition request
    do {
        try requestHandler.perform([request])
    } catch {
        print("Failed to perform text recognition: \(error.localizedDescription)")
        return nil
    }

    return recognizedText.isEmpty ? nil : recognizedText
}

// Modified main function to accept command-line argument
func main() {
    let arguments = CommandLine.arguments

    // Check if the image path is provided
    guard arguments.count > 1 else {
        print("Usage: ocr <image_path>")
        return
    }

    // The first argument is the executable name, so we use the second one
    let imagePath = arguments[1]

    // Perform text recognition
    if let text = recognizeText(from: imagePath) {
        print("Recognized Text:\n\(text)")
    } else {
        print("No text recognized.")
    }
}

main()
