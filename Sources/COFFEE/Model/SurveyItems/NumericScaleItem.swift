//
//  NumericScaleSurveyItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

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
    public let color: String
    
    public init(value: Double, label: String, color: String) {
        self.value = value
        self.label = label
        self.color = color
    }
}
