//
//  LocationPickerResponse.swift
//
//
//  Created by Victor Prüfer on 04.05.21.
//

import Foundation

public struct LocationPickerResponse: ItemResponse, Codable {
    
    /// Specifies the type of the item this response is referring to
    public let type: SurveyItemType
    /// The unique identifier of the item this response is referring to
    public let itemIdentifier: String
    /// The value of the response. The value type are the coordinates of the shared location
    public let value: [CoordinateType: Double]
    
    /// A description of the value.
    public var valueDescription: String {
        guard let longitude = value.first(where: { $0.key == .longitude }),
              let latitude = value.first(where: { $0.key == .latitude }) else {
            return "Invalid value"
        }
        return "Longitude: \(longitude); Latitude: \(latitude)"
    }
    
    public init(itemIdentifier: String, value: [CoordinateType: Double]) {
        self.type = .locationPicker
        self.itemIdentifier = itemIdentifier
        self.value = value
    }
}

/// Enum to specify the type of a survey item
public enum CoordinateType: String, Codable {
    case longitude
    case latitude
}
