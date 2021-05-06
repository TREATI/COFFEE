//
//  SliderResponse.swift
//  COFFEE
//
//  Created by Victor Prüfer on 06.05.21.
//

import Foundation

public class SliderResponse: ObservableObject, ItemResponse, Codable {
    
    /// Specifies the type of the item this response is referring to
    public var type: SurveyItemType
    /// The unique identifier of the item this response is referring to
    public var itemIdentifier: String
    /// The value of the response. The value type is a double which reflects the selected numeric scale step / position
    public var value: Double?
    /// Boolean defining whether the current input is valid
    public var isValidInput: Bool {
        return value != nil
    }
    /// A description of the value
    public var valueDescription: String {
        guard let value = value else {
            return "No value"
        }
        return String(value)
    }
    
    public init(itemIdentifier: String, initialValue: Double?) {
        self.type = .slider
        self.itemIdentifier = itemIdentifier
        self.value = initialValue
    }
}
