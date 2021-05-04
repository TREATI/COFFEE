//
//  TextInputSurveyItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

/// This item lets the respondent enter a text
public struct TextualItem: SurveyItem, Codable {
    // General attributes
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String
    public let isOptional: Bool
    
    public init(identifier: String, question: String, description: String, isOptional: Bool) {
        self.type = .text
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isOptional = isOptional
    }
}
