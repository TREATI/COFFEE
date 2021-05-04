//
//  NumericScaleResponse.swift
//
//
//  Created by Victor Prüfer on 04.05.21.
//

import Foundation

public struct NumericScaleResponse: ItemResponse2, Codable {
    
    /// The value type is a double which reflects the selected numeric scale step / position
    public typealias ResponseValueType = Double
    
    /// Specifies the type of the item this response is referring to
    public var type: SurveyItemType
    /// The unique identifier of the item this response is referring to
    public var itemIdentifier: String
    /// The value of the response
    public var value: ResponseValueType?
    /// Boolean defining whether the current input is valid
    public var isValidInput: Bool {
        return value != nil
    }
    
    public init(itemIdentifier: String, initialValue: ResponseValueType?) {
        self.type = .numericScale
        self.itemIdentifier = itemIdentifier
        self.value = initialValue
    }
}
