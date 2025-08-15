//
//  ImageHandler.swift
//  Furlogix
//
//  Created by Scott Williams on 2025-08-06.
//
import SwiftUI

class ImageHandler {
  func saveImage(_ image: UIImage) -> String? {
    let filename = "pet_\(Int(Date().timeIntervalSince1970)).jpg"
    let documentsURL = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask)[0]
    let url = documentsURL.appendingPathComponent(filename)

    if let data = image.jpegData(compressionQuality: 0.8) {
      do {
        try data.write(to: url)
        return filename  // Return just filename, not full path
      } catch {
        print("Error saving image: \(error)")
        return nil
      }
    }
    return nil
  }

  func loadImage(from path: String) -> UIImage? {
    if path.hasPrefix("file://") || path.hasPrefix("/") {
      let cleanPath = path.hasPrefix("file://") ? String(path.dropFirst(7)) : path
      return UIImage(contentsOfFile: cleanPath)
    } else {
      let documentsURL = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)[0]
      let fileURL = documentsURL.appendingPathComponent(path)
      return UIImage(contentsOfFile: fileURL.path)
    }
  }
}
