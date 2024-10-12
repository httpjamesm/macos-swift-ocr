// Sources/TextRecognition/TextRecognition.swift

import SwiftRs
import AppKit
import Vision

// Helper function to convert NSImage to CGImage
func convertToCGImage(_ image: NSImage) -> CGImage? {
    guard let tiffData = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiffData) else {
        return nil
    }
    return bitmap.cgImage
}

@_cdecl("recognize_text")
public func recognizeText(imagePath: SRString) -> SRString? {
    // Convert SRString to Swift String
    let path = imagePath.toString()
    
    // Load the image from the provided path
    guard let nsImage = NSImage(contentsOfFile: path),
          let cgImage = convertToCGImage(nsImage) else {
        // Return nil if the image cannot be loaded
        return nil
    }
    
    // Create a Vision request handler
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    
    // Variable to hold the recognized text
    var recognizedText = ""
    
    // Create the text recognition request
    let request = VNRecognizeTextRequest { (request, error) in
        if let error = error {
            // Handle the error (optional: log or return a specific string)
            print("Text recognition error: \(error.localizedDescription)")
            return
        }
        
        // Process the results
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
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
        // Handle the error (optional: log or return a specific string)
        print("Failed to perform text recognition: \(error.localizedDescription)")
        return nil
    }
    
    // Return the recognized text as SRString
    return recognizedText.isEmpty ? nil : SRString(recognizedText)
}
