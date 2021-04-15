//
//  Reminder.swift
//  COFFEE
//
//  Created by Victor Prüfer on 15.03.21.
//

import Foundation


/// Reflects one survey reminder. Note that this is a temporary implementation that will be transformed into an object-oriented approach in the future
public struct Reminder: Codable {
    // General attributes
    public let type: ReminderType
    public let description: String
    // Additional attributes for type 'dateTime'
    public let date: Date?
    // Additional attributes for type 'interval'
    public let startTime: Date?
    public let endTime: Date?
    public let interval: Int? // in minutes
    // Additional attributes for type 'locationChange'
    public let threshold: Int? // in meters
    
    public init(type: ReminderType, description: String, date: Date?, startTime: Date?, endTime: Date?, interval: Int?, threshold: Int?) {
        self.type = type
        self.description = description
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.interval = interval
        self.threshold = threshold
    }
}
    

// Enum to specify the type of a survey reminder
public enum ReminderType: String, Codable {
    case dateTime
    case interval
    case locationChange
}
