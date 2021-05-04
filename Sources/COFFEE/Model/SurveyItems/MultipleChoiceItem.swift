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
    public var isMandatory: Bool
    
    /// Specify a set of available options
    public let multipleChoiceOptions: [MultipleChoiceOption]
    /// The minimum number of selections required
    public var minNumberOfSelections: Int?
    /// The maximum number of selections allowed
    public var maxNumberOfSelections: Int?
    
    public init(identifier: String = UUID().uuidString, question: String, description: String, multipleChoiceOptions: [MultipleChoiceOption]) {
        self.type = .multipleChoice
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isMandatory = true
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
