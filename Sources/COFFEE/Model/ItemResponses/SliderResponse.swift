//
//  SliderResponse.swift
//  COFFEE
//
//  Created by Victor Prüfer on 06.05.21.
//

import Foundation

public struct SliderResponse: ItemResponse, Codable {
    
    /// Specifies the type of the item this response is referring to
    public let type: SurveyItemType
    /// The unique identifier of the item this response is referring to
    public let itemIdentifier: String
    /// The value of the response. The value type is a double which reflects the selected numeric scale step / position
    public let value: Double
 
    /// A description of the value
    public var valueDescription: String {
        return String(value)
    }
    
    public init(itemIdentifier: String, value: Double) {
        self.type = .slider
        self.itemIdentifier = itemIdentifier
        self.value = value
    }
}
