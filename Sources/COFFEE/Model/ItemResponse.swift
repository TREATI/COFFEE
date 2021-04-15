//
//  ItemResponse.swift
//  COFFEE
//
//  Created by Victor Prüfer on 22.02.21.
//

import Foundation

/// Reflects the response to one survey question. Note that this is a temporary implementation that will be transformed into an object-oriented approach in the future
public class ItemResponse: Codable, ObservableObject {
    // General attributes
    public let type: SurveyItemType
    public let surveyItemID: String
    
    // Ordinal Scale
    public var responseOrdinalScale: Double?
    
    // Nominal Scale
    public var responseNominalScale: Int?
    
    // Multiple Choice
    public var responseMultipleChoice: [Int]?
    
    // Location Picker
    public var responseLocationPickerLongitude: Double?
    public var responseLocationPickerLatitude: Double?
    
    // Text Picker
    public var responseTextInput: String?
    
    public init(type: SurveyItemType, surveyItemID: String) {
        self.type = type
        self.surveyItemID = surveyItemID
    }
    
    public var isValidInput: Bool {
        switch type {
            case .ordinalScale:
                return responseOrdinalScale != nil
            case .nominalScale:
                return responseNominalScale != nil
            case .multipleChoice:
                return !(responseMultipleChoice?.isEmpty ?? true)
            case .textInput:
                return true
            case .locationPicker:
                return true
        }
    }
}

/// Make item respone printable on console
extension ItemResponse: CustomStringConvertible {
    public var description: String {
        if let responseOrdinalScale = responseOrdinalScale {
            return "Selection on ordinal scale in question <\(surveyItemID)>: \(responseOrdinalScale)"
        } else if let responseNominalScale = responseNominalScale {
            return "Selection on nominal scale in question <\(surveyItemID)>: \(responseNominalScale)"
        } else if let responseMultipleChoice = responseMultipleChoice {
            return "Selected multiple choice options in question <\(surveyItemID)>: \(responseMultipleChoice)"
        } else if let responseLocationPickerLongitude = responseLocationPickerLongitude, let responseLocationPickerLatitude = responseLocationPickerLatitude {
            return "Shared coordinates in question <\(surveyItemID)>: \(responseLocationPickerLongitude), \(responseLocationPickerLatitude)"
        } else if let responseTextInput = responseTextInput {
            return "Text response in question <\(surveyItemID)>: \(responseTextInput)"
        }
        return "Unknown or invalid response in question <\(surveyItemID)>"
    }
}