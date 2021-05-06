//
//  MultipleChoiceItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation
import SwiftUI

/// This item displays a set of options and lets the respondent choose multiple ones
public struct MultipleChoiceItem: SurveyItem, Codable {
    // General attributes
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String
    public var isMandatory: Bool
    
    /// Specify a set of available options
    public let options: [Self.Option]
    /// The minimum number of selections required
    public var minNumberOfSelections: Int
    /// The maximum number of selections allowed
    public var maxNumberOfSelections: Int
    /// Whether the options should be sorted ascending or descending (by identifier)
    public var isAscendingOrder: Bool
    
    /// The coding keys for a multiple choice item
    enum CodingKeys: String, CodingKey {
        case type
        case identifier
        case question
        case description
        case isMandatory
        case options
        case minNumberOfSelections
        case maxNumberOfSelections
        case isAscendingOrder
    }
    
    public init(identifier: String = UUID().uuidString, question: String, description: String, options: [Self.Option], isSingleChoice: Bool = false) {
        self.type = .multipleChoice
        self.isMandatory = true
        self.isAscendingOrder = true
        self.minNumberOfSelections = 1
        self.maxNumberOfSelections = isSingleChoice ? 1 : Int.max
        
        self.identifier = identifier
        self.question = question
        self.description = description
        self.options = options
    }
    
    /// Creates a new instance of a multiple choice item from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all values or set default values
        type = .multipleChoice
        identifier = try container.decode(String.self, forKey: .identifier)
        question = try container.decode(String.self, forKey: .question)
        description = try container.decode(String.self, forKey: .description)
        if let isMandatory = try? container.decode(Bool.self, forKey: .isMandatory) {
            self.isMandatory = isMandatory
        } else {
            self.isMandatory = true
        }
        options = try container.decode([MultipleChoiceItem.Option].self, forKey: .options)
        if let minNumberOfSelections = try? container.decode(Int.self, forKey: .minNumberOfSelections) {
            self.minNumberOfSelections = minNumberOfSelections
        } else {
            self.minNumberOfSelections = 1
        }
        if let maxNumberOfSelections = try? container.decode(Int.self, forKey: .maxNumberOfSelections) {
            self.maxNumberOfSelections = maxNumberOfSelections
        } else {
            self.maxNumberOfSelections = Int.max
        }
        if let isAscendingOrder = try? container.decode(Bool.self, forKey: .isAscendingOrder) {
            self.isAscendingOrder = isAscendingOrder
        } else {
            self.isAscendingOrder = true
        }
    }
    
    /// One multiple choice option
    public struct Option: Codable {
        /// A unique numeric value for identification purposes
        public let identifier: Int
        /// Human-readable description of the option
        public let label: String
        /// A color associated with the option
        public let color: Color?
        
        /// The coding keys for a numeric scale step
        enum CodingKeys: String, CodingKey {
            case identifier
            case label
            case color
        }
        
        public init(identifier: Int, label: String, color: Color? = nil) {
            self.identifier = identifier
            self.label = label
            self.color = color
        }
        
        /// Encodes an instance of numeric scale step
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            // Encode all regular values
            try container.encode(identifier, forKey: .identifier)
            try container.encode(label, forKey: .label)
            if let color = color {
                try container.encode(color.hexString, forKey: .color)
            }
        }
        
        /// Creates a new instance of numeric scale step from a decoder
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Decode all available values or set default values
            identifier = try container.decode(Int.self, forKey: .identifier)
            label = try container.decode(String.self, forKey: .label)
            if let colorHex = try? container.decode(String.self, forKey: .color) {
                color = Color(hexString: colorHex)
            } else {
                color = nil
            }
        }
    }
}
