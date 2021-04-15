//
//  MockProvider.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

/// This class is for testing purposes. It provides mock surveys
public class MockProvider {
    
    /// Returns multiple mock surveys
    public static func getMultipleSurveys() -> [Survey] {
        // Decode json with mock surveys
        guard let decodedMockSurvey = Self.parseMockData() else {
            return []
        }
        return decodedMockSurvey
    }
    
    /// Returns a single mock survey
    public static func getSingleSurvey() -> Survey {
        return getMultipleSurveys()[3]
    }
    
    // Parses mock survey from a local json file
    static private func parseMockData() -> [Survey]? {
        guard let url = Bundle.module.url(forResource: "MockSurveys", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601;
        do {
            let decodedSurvey = try decoder.decode([Survey].self, from: data)
            return decodedSurvey
        } catch let error {
            print(error)
        }
        return nil
    }
    
}
