//
//  TextInputSurveyItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

/// This item lets the respondent enter a text
public struct TextItem: SurveyItem, Codable {
    // General attributes
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String
    public var isMandatory: Bool
    
    /// The minimum number of characters required to consider the input valid
    public var minNumberOfCharacters: Int
    /// Whether the text input is supposed to be numerical
    public var isInputNumerical: Bool
    
    /// The coding keys for a text item
    enum CodingKeys: String, CodingKey {
        case type
        case identifier
        case question
        case description
        case isMandatory
        case minNumberOfCharacters
        case isInputNumerical
    }
    
    public init(identifier: String = UUID().uuidString, question: String, description: String) {
        self.type = .text
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isMandatory = true
        self.minNumberOfCharacters = 5
        self.isInputNumerical = false
    }
    
    /// Creates a new instance of text item from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = .text
        
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
        if let minNumberOfCharacters = try? container.decode(Int.self, forKey: .minNumberOfCharacters) {
            self.minNumberOfCharacters = minNumberOfCharacters
        } else {
            self.minNumberOfCharacters = 5
        }
        if let isInputNumerical = try? container.decode(Bool.self, forKey: .isInputNumerical) {
            self.isInputNumerical = isInputNumerical
        } else {
            self.isInputNumerical = false
        }
    }
}
