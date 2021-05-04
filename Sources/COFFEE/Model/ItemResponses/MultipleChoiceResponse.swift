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
            return (minNumberOfSelections...maxNumberOfSelections) ~= selections.count
        }
        return false
    }
    
    /// The minimum number of selections required
    private var minNumberOfSelections: Int
    /// The maximum number of selections allowed
    private var maxNumberOfSelections: Int
    
    public init(itemIdentifier: String, initialValue: ResponseValueType?, minNumberOfSelections: Int = 1, maxNumberOfSelections: Int = Int.max) {
        self.type = .numericScale
        self.itemIdentifier = itemIdentifier
        self.value = initialValue ?? []
        self.minNumberOfSelections = minNumberOfSelections
        self.maxNumberOfSelections = maxNumberOfSelections
    }
}
