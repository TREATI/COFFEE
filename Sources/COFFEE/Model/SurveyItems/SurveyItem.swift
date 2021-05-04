//
//  SurveyItem.swift
//  COFFEE
//
//  Created by Victor Prüfer on 21.02.21.
//

import Foundation

/// All survey item types need to implement this protocol
public protocol SurveyItem: Codable {
    /// Specifies the survey item type (e.g. multiple choice, text, ...)
    var type: SurveyItemType { get }
    /// A unique identifier to identify the item and to associate responses
    var identifier: String { get }
    /// The actual question that the respondent should answer
    var question: String { get }
    /// A description giving possible additional information such as what input is expected
    var description: String { get }
    /// Specifies whether the survey item can be skipped
    var isOptional: Bool { get }
    /// Specifies the title of the scale (e.g. 'Thermal Sensation Scale')
    var scaleTitle: String? { get }
}

/// Enum to specify the type of a survey item
public enum SurveyItemType: String, Codable {
    case numericScale
    case nominalScale
    case multipleChoice
    case locationPicker
    case textInput
}
