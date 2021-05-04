//
//  Survey.swift
//  COFFEE
//
//  Created by Victor Prüfer on 21.02.21.
//

import Foundation

public struct Survey: Codable {
    public let title: String
    public let description: String
    public var researcher: Researcher?
    public let allowsMultipleSubmissions: Bool
    public let startDate: Date
    public let endDate: Date
    public var items: [SurveyItem] = []
    public let color: String
    public let reminders: [Reminder]
    
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
        try container.encode(allowsMultipleSubmissions, forKey: .allowsMultipleSubmissions)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(color, forKey: .color)
        try container.encode(reminders, forKey: .reminders)

        // Encode the items array (needs special treatment as they need to be assigned manually)
        var itemsContainer = container.nestedUnkeyedContainer(forKey: .items)
        for anItem in items {
            if let ordinalScaleItem = anItem as? NumericScaleItem {
                try itemsContainer.encode(ordinalScaleItem)
            } else if let nominalScaleItem = anItem as? NominalScaleSurveyItem {
                try itemsContainer.encode(nominalScaleItem)
            } else if let multipleChoiceItem = anItem as? MultipleChoiceSurveyItem {
                try itemsContainer.encode(multipleChoiceItem)
            } else if let locationPickerItem = anItem as? LocationPickerSurveyItem {
                try itemsContainer.encode(locationPickerItem)
            } else if let textInputItem = anItem as? TextInputSurveyItem {
                try itemsContainer.encode(textInputItem)
            }
        }
    }
    
    /// Memberwise initializer
    public init(title: String, description: String, researcher: Researcher? = nil, allowsMultipleSubmissions: Bool, startDate: Date, endDate: Date, items: [SurveyItem], color: String, reminders: [Reminder] = []) {
        self.title = title
        self.description = description
        self.researcher = researcher
        self.allowsMultipleSubmissions = allowsMultipleSubmissions
        self.startDate = startDate
        self.endDate = endDate
        self.items = items
        self.color = color
        self.reminders = reminders
    }
    
    /// Creates a new instance of survey from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all regular values
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        researcher = try container.decode(Researcher.self, forKey: .researcher)
        allowsMultipleSubmissions = try container.decode(Bool.self, forKey: .allowsMultipleSubmissions)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        color = try container.decode(String.self, forKey: .color)
        reminders = try container.decode([Reminder].self, forKey: .reminders)
        
        // Decode the items array (needs special treatment as items need to be manually)
        // We create a copy as calling decode() is necessary to get the type but increases the decoder's current index
        var itemsArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.items)
        var itemsArray = itemsArrayForType
        while !itemsArrayForType.isAtEnd {
            let item = try itemsArrayForType.nestedContainer(keyedBy: SurveyItemTypeKey.self)
            let itemType = try item.decode(SurveyItemType.self, forKey: SurveyItemTypeKey.type)

            switch itemType {
                case .numericScale:
                    items.append(try itemsArray.decode(NumericScaleItem.self))
                case .nominalScale:
                    items.append(try itemsArray.decode(NominalScaleSurveyItem.self))
                case .multipleChoice:
                    items.append(try itemsArray.decode(MultipleChoiceSurveyItem.self))
                case .textInput:
                    items.append(try itemsArray.decode(TextInputSurveyItem.self))
                case .locationPicker:
                    items.append(try itemsArray.decode(LocationPickerSurveyItem.self))
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
