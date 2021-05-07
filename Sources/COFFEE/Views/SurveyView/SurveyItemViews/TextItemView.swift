//
//  TextItemView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 01.03.21.
//

#if !os(macOS)

import SwiftUI
import Combine

struct TextItemView: View {
    
    @StateObject var viewModel: ViewModel
    
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
            
    var body: some View {
        ZStack (alignment: .topLeading) {
            // Placeholder text
            if viewModel.currentTextInput.isEmpty {
                Text("Write here...")
                    .foregroundColor(Color(.systemGray2))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 5)
                    .allowsHitTesting(false)
            }
            // The actual multiline text editor
            TextEditor(text: $viewModel.currentTextInput)
                .frame(minHeight: 38)
            // Invisible text to auto-size the text area (workaround)
            Text(viewModel.currentTextInput)
                .opacity(0)
                .padding(.all, 8)
        }
        .background(Color(.systemGray5))
        .cornerRadius(6)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
}

extension TextItemView {
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        private var itemToRender: TextItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel
        // Reference to the item response
        private var itemResponse: TextResponse?
        
        // Store the current text input locally
        @Published var currentTextInput: String = ""
        
        var handler: AnyCancellable?
        
        init(itemToRender: TextItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
            self.itemResponse = surveyViewModel.currentItemResponse as? TextResponse
            
            // Once the text is changed locally, update the item response
            handler = $currentTextInput.sink { (textChange) in
                self.itemResponse?.value = textChange
                self.objectWillChange.send()
                self.surveyViewModel.objectWillChange.send()
            }
        }
    }
}

#endif
