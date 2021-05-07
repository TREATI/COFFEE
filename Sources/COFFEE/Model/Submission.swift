//
//  Submission.swift
//  COFFEE
//
//  Created by Victor Prüfer on 05.04.21.
//

import Foundation

/// A submission groups multiple item responses
public struct Submission: Codable {
    public let submissionDate: Date
    public let responses: [ItemResponse]
    
    /// The coding keys for a text item
    enum CodingKeys: String, CodingKey {
        case submissionDate
        case responses
    }
    
    /// Creates a new instance of submission from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        // Decode all required values
        self.submissionDate = try container.decode(Date.self, forKey: .submissionDate)
        self.responses = try container.decode([ItemResponse].self, forKey: .responses)
    }
}

extension Submission: CustomStringConvertible {
    
    public var description: String {
        let responsesString = responses.map({ "+ " + $0.description }).joined(separator: "\n")
        return "Submission at \(submissionDate.description):\n" + responsesString
    }
    
}
