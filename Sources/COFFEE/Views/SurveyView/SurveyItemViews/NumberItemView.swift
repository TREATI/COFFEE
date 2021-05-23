//
//  TextItemView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 22.05.21.
//

#if !os(macOS)

import SwiftUI
import Combine

struct NumberItemView: View {
    
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
    
    var body: some View {
        TextField("Hey", text: viewModel.numberProxy)
            .keyboardType(.decimalPad)
            .onChange(of: viewModel.numberProxy.wrappedValue, perform: { value in
                surveyViewModel.objectWillChange.send()
            })
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            .frame(minHeight: 38)
            .background(Color(.systemGray5))
            .cornerRadius(6)
    }
}

extension NumberItemView {
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        @Published var itemToRender: NumberItem
                
        // Proxy to convert between numeric model and textual view
        var numberProxy: Binding<String> {
            Binding<String>(
                get: {
                    guard let currentResponse = self.itemToRender.currentResponse else {
                        return ""
                    }
                    return String(format: "%.02f", Double(currentResponse))
                },
                set: {
                    if let value = NumberFormatter().number(from: $0) {
                        self.itemToRender.currentResponse = value.doubleValue
                    } else {
                        self.itemToRender.currentResponse = nil
                    }
                }
            )
        }
        
        init(itemToRender: NumberItem) {
            self.itemToRender = itemToRender
        }
    }
}

#endif
