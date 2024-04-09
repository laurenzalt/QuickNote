//
//  Note.swift
//  QuickNote
//
//  Created by Altendorfer Laurenz on 09.04.24.
//

import Foundation

struct Note: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var content: String
    var imageData: Data? // Optional image data

    // Custom CodingKeys to handle encoding and decoding of non-conformant types
    enum CodingKeys: CodingKey {
        case id, title, content, imageData
    }

    // Implement Codable conformance to handle `Data?`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encodeIfPresent(imageData, forKey: .imageData)
    }

    // Initializer for creating new notes
    init(title: String, content: String, imageData: Data? = nil) {
        self.title = title
        self.content = content
        self.imageData = imageData
    }
}

