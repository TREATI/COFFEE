//
//  TextInputView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 01.03.21.
//

#if !os(macOS)

import SwiftUI
import Combine

struct TextInputView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
            
    var body: some View {
        TextField("Write here...", text: $viewModel.currentTextInput)
    }
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        private var itemToRender: TextualItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel
        
        // Store the current text input locally
        @Published var currentTextInput: String = ""
        
        var handler: AnyCancellable?
        
        init(itemToRender: TextualItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
            
            // Once the text is changed locally, update the item response
            handler = $currentTextInput.sink { (textChange) in
                if let currentItemResponse = surveyViewModel.currentItemResponse as? TextualResponse {
                    currentItemResponse.value = textChange
                }
                //surveyViewModel.currentItemResponse?.responseTextInput = textChange
            }
        }
    }
}

#endif
