//
//  Survey.swift
//  COFFEE
//
//  Created by Victor Prüfer on 21.02.21.
//

import Foundation
import SwiftUI

public struct Survey: Codable {
    /// Survey title that is shown in the overview screen
    public var title: String?
    /// Description of the survey that is shown in the overview screen
    public var description: String?
    /// The creator of the survey, shown in the overview screen
    public var researcher: Researcher?
    /// Time frame of the survey, shown in the overview screen
    public var startDate: Date?
    public var endDate: Date?
    /// The survey items, each item reflects one question
    public var items: [SurveyItem] = []
    /// The brand color of the survey, which is used for e.g. the buttons
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
        try container.encode(color.hexString, forKey: .color)
        try container.encode(reminders, forKey: .reminders)

        // Encode the items array (needs special treatment as they need to be assigned manually)
        var itemsContainer = container.nestedUnkeyedContainer(forKey: .items)
        for anItem in items {
            if let ordinalScaleItem = anItem as? NumericScaleItem {
                try itemsContainer.encode(ordinalScaleItem)
            } else if let sliderItem = anItem as? SliderItem {
                try itemsContainer.encode(sliderItem)
            } else if let multipleChoiceItem = anItem as? MultipleChoiceItem {
                try itemsContainer.encode(multipleChoiceItem)
            } else if let locationPickerItem = anItem as? LocationPickerItem {
                try itemsContainer.encode(locationPickerItem)
            } else if let textInputItem = anItem as? TextItem {
                try itemsContainer.encode(textInputItem)
            }
        }
    }
    
    /// Memberwise initializer
    public init(items: [SurveyItem], color: Color = Color(hexString: "#8f4068")) {
        self.items = items
        self.color = color
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
        if let colorHex = try? container.decode(String.self, forKey: .color) {
            color = Color(hexString: colorHex)
        } else {
            color = Color(hexString: "#8f4068")
        }
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
                case .slider:
                    items.append(try itemsArray.decode(SliderItem.self))
                case .multipleChoice:
                    items.append(try itemsArray.decode(MultipleChoiceItem.self))
                case .text:
                    items.append(try itemsArray.decode(TextItem.self))
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
