//
//  MockProvider.swift
//  
//
//  Created by Victor Prüfer on 13.04.21.
//

import Foundation

/// This class is for testing purposes. It provides mock surveys
public class MockProvider {
    
    /// Returns a single mock survey
    public static func getSingleSurvey() -> Survey! {
        guard let url = Bundle.main.url(forResource: "MockSurveys", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601;
        do {
            let decodedSurvey = try decoder.decode(Survey.self, from: data)
            return decodedSurvey
        } catch let error {
            print(error)
        }
        return nil
    }
}
