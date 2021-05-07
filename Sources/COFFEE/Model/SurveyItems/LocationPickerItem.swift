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
    public var isMandatory: Bool
    
    /// The coding keys for a location item
    enum CodingKeys: String, CodingKey {
        case type
        case identifier
        case question
        case description
        case isMandatory
    }
    
    public init(identifier: String = UUID().uuidString, question: String, description: String) {
        self.type = .locationPicker
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isMandatory = true
    }
    
    /// Creates a new instance of location picker item from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = .locationPicker
        
        // Decode all required values
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.question = try container.decode(String.self, forKey: .question)
        self.description = try container.decode(String.self, forKey: .description)
        
        // Decode option values / set default values
        if let isMandatory = try? container.decode(Bool.self, forKey: .isMandatory) {
            self.isMandatory = isMandatory
        } else {
            self.isMandatory = true
        }
    }
}
