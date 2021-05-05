//
//  Survey.swift
//  COFFEE
//
//  Created by Victor Prüfer on 21.02.21.
//

import Foundation
import SwiftUI

public struct Survey: Codable {
    public var title: String?
    public var description: String?
    public var researcher: Researcher?
    public var startDate: Date?
    public var endDate: Date?
    public var items: [SurveyItem] = []
    public var color: Color
    public var reminders: [Reminder]?
    
    /// The coding keys for survey
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case researcher
        case allowsMultipleSubmissions
        case startDate
        case endDate
        case items
        case color
        case reminders
    }
    
    /// The coding key for the survey item type in a survey item
    enum SurveyItemTypeKey: CodingKey {
        case type
    }
    
    /// Encodes an instance of survey
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode all regular values
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(researcher, forKey: .researcher)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode("8f4068", forKey: .color)
        try container.encode(reminders, forKey: .reminders)

        // Encode the items array (needs special treatment as they need to be assigned manually)
        var itemsContainer = container.nestedUnkeyedContainer(forKey: .items)
        for anItem in items {
            if let ordinalScaleItem = anItem as? NumericScaleItem {
                try itemsContainer.encode(ordinalScaleItem)
            } else if let multipleChoiceItem = anItem as? MultipleChoiceItem {
                try itemsContainer.encode(multipleChoiceItem)
            } else if let locationPickerItem = anItem as? LocationPickerItem {
                try itemsContainer.encode(locationPickerItem)
            } else if let textInputItem = anItem as? TextualItem {
                try itemsContainer.encode(textInputItem)
            }
        }
    }
    
    /// Memberwise initializer
    public init(items: [SurveyItem], color: Color = Color(UIColor.init(hexString: "#8f4068"))) {
        self.items = items
        self.color = color
        // Ensure the survey is not empty
        assert(!items.isEmpty, "Survey is empty. The survey should have at least one item.")
    }
    
    /// Creates a new instance of survey from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all regular values
        title = try? container.decode(String.self, forKey: .title)
        description = try? container.decode(String.self, forKey: .description)
        researcher = try? container.decode(Researcher.self, forKey: .researcher)
        startDate = try? container.decode(Date.self, forKey: .startDate)
        endDate = try? container.decode(Date.self, forKey: .endDate)
        let colorHex = try container.decode(String.self, forKey: .color)
        color = Color(UIColor.init(hexString: colorHex))
        reminders = try? container.decode([Reminder].self, forKey: .reminders)
        
        // Decode the items array (needs special treatment as items need to be assigned manually)
        // We create a copy as calling decode() is necessary to get the type but increases the decoder's current index
        var itemsArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.items)
        var itemsArray = itemsArrayForType
        while !itemsArrayForType.isAtEnd {
            let item = try itemsArrayForType.nestedContainer(keyedBy: SurveyItemTypeKey.self)
            let itemType = try item.decode(SurveyItemType.self, forKey: SurveyItemTypeKey.type)

            switch itemType {
                case .numericScale:
                    items.append(try itemsArray.decode(NumericScaleItem.self))
                case .multipleChoice:
                    items.append(try itemsArray.decode(MultipleChoiceItem.self))
                case .text:
                    items.append(try itemsArray.decode(TextualItem.self))
                case .locationPicker:
                    items.append(try itemsArray.decode(LocationPickerItem.self))
            }
        }
    }
}

/// Research conductor
public struct Researcher: Codable {
    public var name: String
    public var mail: String
    
    public init(name: String, mail: String) {
        self.name = name
        self.mail = mail
    }
}
