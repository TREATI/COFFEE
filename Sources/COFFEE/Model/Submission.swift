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
}

extension Submission: CustomStringConvertible {
    
    public var description: String {
        let responsesString = responses.map({ "+ " + $0.description }).joined(separator: "\n")
        return "Submission at \(submissionDate.description):\n" + responsesString
    }
    
}
