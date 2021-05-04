//
//  MultipleChoiceItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

/// This item displays a set of options and lets the respondent choose multiple ones
public struct MultipleChoiceItem: SurveyItem, Codable {
    // General attributes
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String
    public let isOptional: Bool
    public let scaleTitle: String?
    
    // Additional attributes for item type "MultipleChoice"
    /// Specify a set of available options
    public let multipleChoiceOptions: [MultipleChoiceOption]
    
    public init(identifier: String, question: String, description: String, isOptional: Bool, scaleTitle: String?, multipleChoiceOptions: [MultipleChoiceOption]) {
        self.type = .multipleChoice
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isOptional = isOptional
        self.scaleTitle = scaleTitle
        self.multipleChoiceOptions = multipleChoiceOptions
    }
}

/// One multiple choice option
public struct MultipleChoiceOption: Codable {
    /// A unique numeric value for identification purposes
    public let identifier: Int
    /// Human-readable description of the option
    public let label: String
    
    public init(identifier: Int, label: String) {
        self.identifier = identifier
        self.label = label
    }
}
