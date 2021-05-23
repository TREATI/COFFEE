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
    
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
            
    var body: some View {
        ZStack (alignment: .topLeading) {
            // Placeholder text
            if viewModel.itemToRender.currentResponse.isEmpty {
                Text("Write here...")
                    .foregroundColor(Color(.systemGray2))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 5)
                    .allowsHitTesting(false)
            }
            // The actual multiline text editor
            TextEditor(text: $viewModel.itemToRender.currentResponse)
                .onChange(of: viewModel.itemToRender.currentResponse, perform: { value in
                    surveyViewModel.objectWillChange.send()
                })
                .keyboardType(viewModel.itemToRender.isInputNumerical ? .numberPad : .default)
                .frame(minHeight: 38)
            // Invisible text to auto-size the text area (workaround)
            Text(viewModel.itemToRender.currentResponse)
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
        @Published var itemToRender: TextItem
                
        init(itemToRender: TextItem) {
            self.itemToRender = itemToRender
        }
    }
}

#endif
