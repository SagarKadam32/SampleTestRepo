//
//  Gist.swift
//  RestHub
//
//  Created by Sagar Kadam on 16/05/22.
//

import Foundation


struct Gist: Encodable {
    var id: String?
    var isPublic: Bool
    var description: String
    var files: [String:File]
    
    enum CodingKeys: String, CodingKey {
        case id, description, files, isPublic = "public"
    }
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(files, forKey: .files)
    }
}

extension Gist : Decodable {
    
    // Manual Decoding
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: CodingKeys.id)
        self.isPublic = try container.decode(Bool.self, forKey: CodingKeys.isPublic)
        self.description = try container.decode(String.self, forKey: CodingKeys.description) ?? "Description is nil"
        self.files = try container.decode([String:File].self, forKey: CodingKeys.files)
    }
}

struct File: Codable{
    var content: String?
}