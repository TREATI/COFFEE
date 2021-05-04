//
//  LocationPickerItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

/// This item asks the respondent to share their current location
public struct LocationPickerItem: SurveyItem, Codable {
    // General attributes
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String
    public let isOptional: Bool
    
    public init(identifier: String = UUID().uuidString, question: String, description: String, isOptional: Bool) {
        self.type = .locationPicker
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isOptional = isOptional
    }
}
