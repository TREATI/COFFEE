//
//  TextualResponse.swift
//
//
//  Created by Victor Prüfer on 04.05.21.
//

import Foundation

public struct TextualResponse: ItemResponse2, Codable {
    
    /// The value type is a String that reflects the textual input
    public typealias ResponseValueType = String
    
    /// Specifies the type of the item this response is referring to
    public var type: SurveyItemType
    /// The unique identifier of the item this response is referring to
    public var itemIdentifier: String
    /// The value of the response
    public var value: ResponseValueType?
    /// Boolean defining whether the current input is valid
    public var isValidInput: Bool {
        guard let value = value else {
            return false
        }
        return value.count > minNumberOfCharacters
    }
    
    /// The minimum number of characters required to consider the input valid
    private var minNumberOfCharacters: Int
    
    public init(itemIdentifier: String, initialValue: ResponseValueType?, minNumberOfCharacters: Int = 5) {
        self.type = .text
        self.itemIdentifier = itemIdentifier
        self.value = initialValue ?? ""
        self.minNumberOfCharacters = minNumberOfCharacters
    }
}
