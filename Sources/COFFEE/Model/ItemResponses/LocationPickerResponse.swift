//
//  LocationPickerResponse.swift
//
//
//  Created by Victor Prüfer on 04.05.21.
//

import Foundation

public class LocationPickerResponse: ObservableObject, ItemResponse, Codable {
    
    /// Specifies the type of the item this response is referring to
    public var type: SurveyItemType
    /// The unique identifier of the item this response is referring to
    public var itemIdentifier: String
    /// The value of the response. The value type are the coordinates of the shared location
    public var value: [CoordinateType: Double]?
    /// Boolean defining whether the current input is valid
    public var isValidInput: Bool {
        guard let value = value else {
            return false
        }
        return value.contains(where: { $0.key == .latitude}) &&
            value.contains(where: { $0.key == .longitude}) &&
            value.count == 2
    }
    /// A description of the value.
    public var valueDescription: String {
        guard let value = value,
              let longitude = value.first(where: { $0.key == .longitude }),
              let latitude = value.first(where: { $0.key == .latitude }) else {
            return "No value"
        }
        return "Longitude: \(longitude); Latitude: \(latitude)"
    }
    
    
    public init(itemIdentifier: String) {
        self.type = .locationPicker
        self.itemIdentifier = itemIdentifier
    }
}

/// Enum to specify the type of a survey item
public enum CoordinateType: String, Codable {
    case longitude
    case latitude
}
