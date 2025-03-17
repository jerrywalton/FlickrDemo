//
//  FlickrResponse.swift
//  FlickerDemo
//
//  Created by Jerry Walton on 3/16/25.
//
import Foundation

struct FlickrResponse: Codable {
    let items: [FlickrItem]
    let title: String
}

struct FlickrItem: Codable, Identifiable {
    let title: String
    let link: String
    let media: Media
    let description: String
    let published: String
    let author: String
    
    var id: String { link }
    
    struct Media: Codable {
        let m: String
        
        enum CodingKeys: String, CodingKey {
            case m = "m"
        }
    }
    
    // Parse image dimensions from description
    var imageDimensions: (width: Int, height: Int)? {
        let pattern = "width=\"(\\d+)\" height=\"(\\d+)\""
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: description, range: NSRange(description.startIndex..., in: description)),
              let widthRange = Range(match.range(at: 1), in: description),
              let heightRange = Range(match.range(at: 2), in: description),
              let width = Int(description[widthRange]),
              let height = Int(description[heightRange]) else {
            return nil
        }
        return (width, height)
    }
}
