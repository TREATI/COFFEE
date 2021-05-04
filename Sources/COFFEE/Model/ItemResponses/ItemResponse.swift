//
//  ItemResponse.swift
//  COFFEE
//
//  Created by Victor Prüfer on 22.02.21.
//

import Foundation

/// All item responses need to implement this protocol
public protocol ItemResponse: Codable {
    /// Specifies the type of the item this response is referring to
    var type: SurveyItemType { get }
    /// The unique identifier of the item this response is referring to
    var itemIdentifier: String { get }
    /// Return a readable description of the value
    var valueDescription: String { get }
    /// Boolean defining whether the current input is valid
    var isValidInput: Bool { get }
}

extension ItemResponse {
    public var description: String {
        return "Response to <\(itemIdentifier)>: \(valueDescription)"
    }
}
