//
//  MultipleChoiceResponse.swift
//
//
//  Created by Victor Prüfer on 04.05.21.
//

import Foundation

public class MultipleChoiceResponse: ObservableObject, ItemResponse, Codable {
    
    /// Specifies the type of the item this response is referring to
    public var type: SurveyItemType
    /// The unique identifier of the item this response is referring to
    public var itemIdentifier: String
    /// The value of the response. The value type is an array of the selected options' identifiers
    public var value: [Int] = []
    
    /// Boolean defining whether the current input is valid
    public var isValidInput: Bool {
        return (minNumberOfSelections...maxNumberOfSelections) ~= value.count
    }
    /// A description of the value
    public var valueDescription: String {
        return String(describing: value)
    }
    
    /// The minimum number of selections required
    private var minNumberOfSelections: Int
    /// The maximum number of selections allowed
    private var maxNumberOfSelections: Int
    
    /// The coding keys for a multiple choice response
    enum CodingKeys: String, CodingKey {
        case type
        case itemIdentifier
        case value
        case minNumberOfSelections
        case maxNumberOfSelections
    }
    
    public init(itemIdentifier: String, minNumberOfSelections: Int = 1, maxNumberOfSelections: Int = Int.max) {
        self.type = .multipleChoice
        self.itemIdentifier = itemIdentifier
        self.minNumberOfSelections = minNumberOfSelections
        self.maxNumberOfSelections = maxNumberOfSelections
    }
    
    // Encodes an instance of multiple choice response
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode all required values
        try container.encode(type, forKey: .type)
        try container.encode(itemIdentifier, forKey: .itemIdentifier)
        try container.encode(value, forKey: .value)
    }
}
