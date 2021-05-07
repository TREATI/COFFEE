//
//  TextResponse.swift
//
//
//  Created by Victor Prüfer on 04.05.21.
//

import Foundation

public class TextResponse: ObservableObject, ItemResponse, Codable {
    
    /// Specifies the type of the item this response is referring to
    public var type: SurveyItemType
    /// The unique identifier of the item this response is referring to
    public var itemIdentifier: String
    /// The value of the response. The value type is a String that reflects the textual input
    public var value: String = ""
    
    /// Boolean defining whether the current input is valid
    public var isValidInput: Bool {
        return value.count > minNumberOfCharacters
    }
    /// A description of the value
    public var valueDescription: String {
        return String(describing: value)
    }
    
    /// The minimum number of characters required to consider the input valid
    private var minNumberOfCharacters: Int
    
    /// The coding keys for a multiple choice response
    enum CodingKeys: String, CodingKey {
        case type
        case itemIdentifier
        case value
        case minNumberOfCharacters
    }
    
    public init(itemIdentifier: String, minNumberOfCharacters: Int = 5) {
        self.type = .text
        self.itemIdentifier = itemIdentifier
        self.minNumberOfCharacters = minNumberOfCharacters
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
