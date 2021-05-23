//
//  SliderItem.swift
//  COFFEE
//
//  Created by Victor Prüfer on 06.05.21.
//

import Foundation
import SwiftUI

/// This question type displays a numeric scale
public final class SliderItem: ObservableObject, SurveyItem, Codable {

    // MARK: - Public Properties
    
    // MARK: General item attributes required by the 'SurveyItem' protocol
    
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String?
    public var isMandatory: Bool
    
    /// Whether the current response is valid
    @Published public var isResponseValid: Bool = true
    public var isResponseValidPublished: Published<Bool> { _isResponseValid }
    public var isResponseValidPublisher: Published<Bool>.Publisher { $isResponseValid }
    
    // MARK: Item-specific properties

    /// Specify at least two steps to define the scale's range
    public let steps: [SliderItem.Step]
    /// Specify whether the scale is discrete or continous
    public var isContinuous: Bool
    /// Specify whether the slider value should be hidden or not
    public var showSliderValue: Bool
    
    /// The coding keys for a text item
    enum CodingKeys: String, CodingKey {
        case type
        case identifier
        case question
        case description
        case isMandatory
        case steps
        case isContinuous
        case showSliderValue
    }
    
    // MARK: - Internal Properties
    
    /// The current response on this item
    @Published var currentResponse: Double
    
    /// Compute whether all steps have an associated color
    public var isColored: Bool {
        return steps.first(where: { $0.color == nil }) == nil
    }
    
    // MARK: - Initialization
    
    /// Default initializer for `SliderItem`
    /// - Parameters:
    ///   - identifier: An identifier to be able to associate the responses to the question. By default set to a random uuid
    ///   - question: The question that the respondent is supposed to answer with the slider
    ///   - description: A more detailed description with additional instructions on how to answer the question
    ///   - steps: The steps that define the slider range. There must be at least 2 steps
    ///   - isContinuous: Specifies whether the slider should be discrete or continuous
    public init(identifier: String = UUID().uuidString, question: String, description: String? = nil, steps: [SliderItem.Step], isContinuous: Bool = true) {
        self.type = .slider
        self.isMandatory = true
        self.showSliderValue = true
        
        self.identifier = identifier
        self.question = question
        self.description = description
        self.steps = steps
        self.isContinuous = isContinuous
        
        // Initialize a response instance for this item
        if isContinuous {
            // For continous scales, center slider position
            let scaleRangeMax = steps.max(by: { $0.value < $1.value })?.value ?? 1
            let scaleRangeMin = steps.min(by: { $0.value < $1.value })?.value ?? -1
            let scaleRangeCenter = (Double(scaleRangeMax) - abs(Double(scaleRangeMin))) / 2.0
            // Setup initial response value
            self.currentResponse = scaleRangeCenter
        } else {
            // For discrete scales, select middle position
            let middleIndex = (steps.count > 1 ? steps.count - 1 : steps.count) / 2
            // Setup initial response value
            self.currentResponse = steps[middleIndex].value
        }
    }
    
    /// Convenience initializer to setup a discrete `SliderItem` with steps that are named after the values
    /// - Parameters:
    ///   - identifier: An identifier to be able to associate the responses to the question. By default set to a random uuid
    ///   - question: The question that the respondent is supposed to answer with the slider
    ///   - description: A more detailed description with additional instructions on how to answer the question
    ///   - stepRange: The range for which the steps should be created, e.g. `1...10` for ten steps from 1 to 10
    public convenience init(identifier: String = UUID().uuidString, question: String, description: String? = nil, stepRange: ClosedRange<Int>) {
        let steps = stepRange.map({ SliderItem.Step(value: Double($0), label: String($0)) })
        self.init(identifier: identifier, question: question, description: description, steps: steps, isContinuous: false)
        self.showSliderValue = false
        
        // Initialize a response instance for this item
        // For discrete scales, select middle position
        let middleIndex = (steps.count > 1 ? steps.count - 1 : steps.count) / 2
        // Setup initial response value
        self.currentResponse = steps[middleIndex].value
    }
    
    /// Creates a new instance of slider item from a decoder
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = .slider
        
        // Decode all required values
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.question = try container.decode(String.self, forKey: .question)
        self.description = try? container.decode(String.self, forKey: .description)
        self.steps = try container.decode([SliderItem.Step].self, forKey: .steps)
        
        // Decode option values / set default values
        if let isMandatory = try? container.decode(Bool.self, forKey: .isMandatory) {
            self.isMandatory = isMandatory
        } else {
            self.isMandatory = true
        }
        if let isContinuous = try? container.decode(Bool.self, forKey: .isContinuous) {
            self.isContinuous = isContinuous
        } else {
            self.isContinuous = true
        }
        if let showSliderValue = try? container.decode(Bool.self, forKey: .showSliderValue) {
            self.showSliderValue = showSliderValue
        } else {
            self.showSliderValue = true
        }
        
        // Initialize a response instance for this item
        if self.isContinuous {
            // For continous scales, center slider position
            let scaleRangeMax = steps.max(by: { $0.value < $1.value })?.value ?? 1
            let scaleRangeMin = steps.min(by: { $0.value < $1.value })?.value ?? -1
            let scaleRangeCenter = (Double(scaleRangeMax) - abs(Double(scaleRangeMin))) / 2.0
            // Setup initial response value
            self.currentResponse = scaleRangeCenter
        } else {
            // For discrete scales, select middle position
            let middleIndex = (steps.count > 1 ? steps.count - 1 : steps.count) / 2
            // Setup initial response value
            self.currentResponse = steps[middleIndex].value
        }
    }
    
    /// Transforms the current value into a permanent response object
    /// - Returns: An encodable response object if the current value is valid, nil otherwise
    public func generateResponseObject() -> ItemResponse? {
        // Slider value is always valid, but still check in case this behavior changes in the future
        if isResponseValid {
            return SliderResponse(itemIdentifier: identifier, value: currentResponse)
        }
        return nil
    }
}

extension SliderItem {
    
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
        
        /// Default initializer for a single step on a slider.
        /// - Parameters:
        ///   - value: Describes the position on the slider, can also be negative. Should be unique
        ///   - label: The human-readable description for the slider position at the given value
        ///   - color: If all steps have a color provided, the slider computes a color gradient as slider background
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
