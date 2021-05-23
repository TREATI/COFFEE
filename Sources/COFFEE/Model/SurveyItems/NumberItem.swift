//
//  TextInputSurveyItem.swift
//
//
//  Created by Victor Prüfer on 22.05.21.
//

import Foundation

/// This item lets the respondent enter a number
public final class NumberItem: ObservableObject, SurveyItem, Codable {
    
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
        
    /// The coding keys for a text item
    enum CodingKeys: String, CodingKey {
        case type
        case identifier
        case question
        case description
        case isMandatory
    }

    // MARK: - Internal Properties
    
    /// The current response on this item
    @Published var currentResponse: Double? {
        didSet {
            // Validate the value and update the 'isResponseValid' flag accordingly
            self.isResponseValid = currentResponse != nil
        }
    }
    
    // MARK: - Initialization
    
    /// Default initializer for `NumberItem`
    /// - Parameters:
    ///   - identifier: An identifier to be able to associate the responses to the question. By default set to a random uuid
    ///   - question: The question that the respondent is supposed to answer
    ///   - description: A more detailed description with additional instructions on how to answer the question
    public init(identifier: String = UUID().uuidString, question: String, description: String? = nil) {
        self.type = .number
        self.identifier = identifier
        self.question = question
        self.description = description
        self.isMandatory = true
        // Setup initial response value
        self.currentResponse = 0
    }
    
    /// Creates a new instance of text item from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = .number
        
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
        self.currentResponse = 0
    }
    
    /// Transforms the current value into a permanent response object
    /// - Returns: An encodable response object if the current value is valid, nil otherwise
    public func generateResponseObject() -> ItemResponse? {
        if isResponseValid, let currentResponse = currentResponse {
            return NumberResponse(itemIdentifier: identifier, value: currentResponse)
        }
        return nil
    }
}
