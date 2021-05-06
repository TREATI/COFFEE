//
//  SliderItem.swift
//  COFFEE
//
//  Created by Victor Prüfer on 06.05.21.
//

import Foundation
import SwiftUI

/// This question type displays a numeric scale
public struct SliderItem: SurveyItem, Codable {
    // General attributes
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String
    public var isMandatory: Bool
    
    /// Specify at least two steps to define the scale's range
    public let steps: [Self.Step]
    /// Specify whether the scale is discrete or continous
    public var isScaleContinuous: Bool
    /// Specify whether the slider value should be hidden or not
    public var showSliderValue: Bool
    
    /// Compute whether all steps have an associated color
    public var isColored: Bool {
        return steps.first(where: { $0.color == nil }) == nil
    }
    
    public init(identifier: String = UUID().uuidString, question: String, description: String, steps: [Self.Step], isScaleContinuous: Bool = true) {
        self.type = .slider
        self.isMandatory = true
        self.showSliderValue = true
        
        self.identifier = identifier
        self.question = question
        self.description = description
        self.steps = steps
        self.isScaleContinuous = isScaleContinuous
    }
    
    public init(identifier: String = UUID().uuidString, question: String, description: String, stepRange: ClosedRange<Int>) {
        let steps = stepRange.map({ SliderItem.Step(value: Double($0), label: String($0)) })
        self.init(identifier: identifier, question: question, description: description, steps: steps, isScaleContinuous: false)
        self.showSliderValue = false
    }
    
    /// A single step on an ordinal scale
    public struct Step: Codable {
        /// A unique numeric value to describe the step's position on the scale
        public let value: Double
        /// Human-readable description of the step
        public let label: String
        /// A color in hex-format
        public let color: Color?
        
        /// The coding keys for a numeric scale step
        enum CodingKeys: String, CodingKey {
            case value
            case label
            case color
        }
        
        public init(value: Double, label: String, color: Color? = nil) {
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
            if let color = color {
                try container.encode(color.hexString, forKey: .color)
            }
        }
        
        /// Creates a new instance of numeric scale step from a decoder
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Decode all regular values
            value = try container.decode(Double.self, forKey: .value)
            label = try container.decode(String.self, forKey: .label)
            if let colorHex = try? container.decode(String.self, forKey: .color) {
                color = Color(hexString: colorHex)
            } else {
                color = nil
            }
        }
    }
}
