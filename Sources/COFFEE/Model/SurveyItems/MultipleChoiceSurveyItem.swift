//
//  MultipleChoiceSurveyItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

/// This item displays a set of options and lets the respondent choose multiple ones
public struct MultipleChoiceSurveyItem: SurveyItem, Codable {
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
    
    public init(type: SurveyItemType = .multipleChoice, identifier: String, question: String, description: String, isOptional: Bool, scaleTitle: String?, multipleChoiceOptions: [MultipleChoiceOption]) {
        self.type = type
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
    public let value: Int
    /// Human-readable description of the option
    public let label: String
    
    public init(value: Int, label: String) {
        self.value = value
        self.label = label
    }
}
