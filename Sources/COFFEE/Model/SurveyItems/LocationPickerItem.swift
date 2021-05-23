//
//  LocationPickerItem.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

/// This item asks the respondent to share their current location
public final class LocationPickerItem: ObservableObject, SurveyItem, Codable {
    
    // MARK: - Public Properties
    
    // MARK: General item attributes required by the 'SurveyItem' protocol
    
    public let type: SurveyItemType
    public let identifier: String
    public let question: String
    public let description: String?
    public var isMandatory: Bool
    
    /// Whether the current response is valid
    @Published public var isResponseValid: Bool = false
    public var isResponseValidPublished: Published<Bool> { _isResponseValid }
    public var isResponseValidPublisher: Published<Bool>.Publisher { $isResponseValid }
    
    // MARK: Item-specific properties
    
    /// The coding keys for a location item
    enum CodingKeys: String, CodingKey {
        case type
        case identifier
        case question
        case description
        case isMandatory
    }
    
    // MARK: - Internal Properties
    
    /// The response on this item
    @Published var currentResponse: [CoordinateType: Double] {
        didSet {
            // Validate the value and update the 'isResponseValid' flag accordingly
            self.isResponseValid = currentResponse.contains(where: { $0.key == .latitude}) &&
                currentResponse.contains(where: { $0.key == .longitude}) &&
                currentResponse.count == 2
        }
    }
    
    // MARK: - Initialization
    
    public init(identifier: String = UUID().uuidString, question: String, description: String? = nil) {
        self.type = .locationPicker
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isMandatory = true
        // Setup initial response value
        self.currentResponse = [:]
    }
    
    /// Creates a new instance of location picker item from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = .locationPicker
        
        // Decode all required values
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.question = try container.decode(String.self, forKey: .question)
        self.description = try? container.decode(String.self, forKey: .description)
        
        // Decode option values / set default values
        if let isMandatory = try? container.decode(Bool.self, forKey: .isMandatory) {
            self.isMandatory = isMandatory
        } else {
            self.isMandatory = true
        }
        // Setup initial response value
        self.currentResponse = [:]
    }
    
    /// Transforms the current value into a permanent response object
    /// - Returns: An encodable response object if the current value is valid, nil otherwise
    public func generateResponseObject() -> ItemResponse? {
        if isResponseValid {
            return LocationPickerResponse(itemIdentifier: identifier, value: currentResponse)
        }
        return nil
    }
}
