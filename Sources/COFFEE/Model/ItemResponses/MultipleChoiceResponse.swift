//
//  MultipleChoiceResponse.swift
//
//
//  Created by Victor Prüfer on 04.05.21.
//

import Foundation

public struct MultipleChoiceResponse: ItemResponse2, Codable {
    
    /// The value type is an array of the selected options' identifiers
    public typealias ResponseValueType = [Int]
    
    /// Specifies the type of the item this response is referring to
    public var type: SurveyItemType
    /// The unique identifier of the item this response is referring to
    public var itemIdentifier: String
    /// The value of the response
    public var value: ResponseValueType?
    /// Boolean defining whether the current input is valid
    public var isValidInput: Bool {
        if let selections = value {
            return selections.count > 0 && selections.count <= maxNumberOfSelections
        }
        return false
    }
    
    /// The maximum number of items allowed
    private var maxNumberOfSelections: Int
    
    public init(itemIdentifier: String, initialValue: ResponseValueType?, maxNumberOfSelections: Int = Int.max) {
        self.type = .numericScale
        self.itemIdentifier = itemIdentifier
        self.value = initialValue ?? []
        self.maxNumberOfSelections = maxNumberOfSelections
    }
}
