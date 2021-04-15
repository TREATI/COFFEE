//
//  TextInputSurveyItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

/// This item lets the respondent enter a text
public struct TextInputSurveyItem: SurveyItem, Codable {
    // General attributes
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String
    public let isOptional: Bool
    public let scaleTitle: String?
    
    // Additional attributes for item type "TextInput"
    public let image: String?
    
    public init(type: SurveyItemType = .textInput, identifier: String, question: String, description: String, isOptional: Bool, scaleTitle: String?, image: String?) {
        self.type = type
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isOptional = isOptional
        self.scaleTitle = scaleTitle
        self.image = image
    }
}
