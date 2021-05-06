//
//  NumericScaleSurveyItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation
import SwiftUI

/// This question type displays a numeric scale
public struct NumericScaleItem: SurveyItem, Codable {
    // General attributes
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String
    public var isMandatory: Bool
    
    /// Specify whether the scale is discrete or continous
    public var isScaleContinous: Bool
    /// Specify at least two steps to define the scale's range
    public let steps: [NumericScaleStep]
    
    public init(identifier: String = UUID().uuidString, question: String, description: String, isScaleContinous: Bool = false, steps: [NumericScaleStep]) {
        self.type = .numericScale
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isMandatory = true
        self.isScaleContinous = isScaleContinous
        self.steps = steps
    }
}

/// A single step on an ordinal scale
public struct NumericScaleStep: Codable {
    /// A unique numeric value to describe the step's position on the scale
    public let value: Double
    /// Human-readable description of the step
    public let label: String
    /// A color in hex-format
    public let color: Color
    
    /// The coding keys for a numeric scale step
    enum CodingKeys: String, CodingKey {
        case value
        case label
        case color
    }
    
    public init(value: Double, label: String, color: Color) {
        self.value = value
        self.label = label
        self.color = color
    }
    
    /// Encodes an instance of numeric scale step
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode all regular values
        try container.encode(value, forKey: .value)
        try container.encode(label, forKey: .label)
        try container.encode("8f4068", forKey: .color)
    }
    
    /// Creates a new instance of numeric scale step from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all regular values
        value = try container.decode(Double.self, forKey: .value)
        label = try container.decode(String.self, forKey: .label)
        let colorHex = try container.decode(String.self, forKey: .color)
        color = Color(UIColor.init(hexString: colorHex))
    }
}
