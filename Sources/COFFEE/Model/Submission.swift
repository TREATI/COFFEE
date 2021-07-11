//
//  Submission.swift
//  COFFEE
//
//  Created by Victor Prüfer on 05.04.21.
//

import Foundation

/// A submission groups multiple item responses
public struct Submission: Codable {
    /// The date of the submission
    public var submissionDate: Date
    /// The responses to the survey questions. For each valid response, there is one response item.
    public var responses: [ItemResponse]
    /// An optional settable identifier to identify the respondent (e.g. a user id)
    public var identifier: String?
    
    /// The coding keys for a text item
    enum CodingKeys: String, CodingKey {
        case submissionDate
        case responses
        case identifier
    }
    
    /// The coding key for the survey item type in a survey item
    enum ItemResponseTypeKey: CodingKey {
        case type
    }
    
    /// Default initializer
    public init(submissionDate: Date, responses: [ItemResponse]) {
        self.submissionDate = submissionDate
        self.responses = responses
    }
    
    /// Creates a new instance of submission from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        // Decode all required values
        self.submissionDate = try container.decode(Date.self, forKey: .submissionDate)
        self.identifier = try? container.decode(String.self, forKey: .identifier)
        self.responses = []
        
        // Decode the responses array (needs special treatment as items need to be assigned manually)
        // We create a copy as calling decode() is necessary to get the type but increases the decoder's current index
        var itemsArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.responses)
        var itemsArray = itemsArrayForType
        while !itemsArrayForType.isAtEnd {
            let item = try itemsArrayForType.nestedContainer(keyedBy: ItemResponseTypeKey.self)
            let itemType = try item.decode(SurveyItemType.self, forKey: ItemResponseTypeKey.type)

            switch itemType {
                case .slider:
                    responses.append(try itemsArray.decode(SliderResponse.self))
                case .multipleChoice:
                    responses.append(try itemsArray.decode(MultipleChoiceResponse.self))
                case .text:
                    responses.append(try itemsArray.decode(TextResponse.self))
                case .locationPicker:
                    responses.append(try itemsArray.decode(LocationPickerResponse.self))
                case .number:
                    responses.append(try itemsArray.decode(NumberResponse.self))
            }
        }
    }
    
    /// Encodes an instance of survey
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode all required values
        try container.encode(submissionDate, forKey: .submissionDate)
        if let identifier = identifier {
            try container.encode(identifier, forKey: .identifier)
        }
            
        // Encode the items array (needs special treatment as they need to be assigned manually)
        var itemsContainer = container.nestedUnkeyedContainer(forKey: .responses)
        for anItem in responses {
            if let sliderItem = anItem as? SliderResponse {
                try itemsContainer.encode(sliderItem)
            } else if let multipleChoiceItem = anItem as? MultipleChoiceResponse {
                try itemsContainer.encode(multipleChoiceItem)
            } else if let locationPickerItem = anItem as? LocationPickerResponse {
                try itemsContainer.encode(locationPickerItem)
            } else if let textInputItem = anItem as? TextResponse {
                try itemsContainer.encode(textInputItem)
            } else if let numberItem = anItem as? NumberResponse {
                try itemsContainer.encode(numberItem)
            }
        }
    }
}

extension Submission: CustomStringConvertible {
    
    public var description: String {
        let responsesString = responses.map({ "+ " + $0.description }).joined(separator: "\n")
        return "Submission [\(identifier ?? "No identifier")] at \(submissionDate.description):\n" + responsesString
    }
    
}
