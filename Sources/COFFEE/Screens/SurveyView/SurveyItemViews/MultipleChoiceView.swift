//
//  MultipleChoiceView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 02.03.21.
//

#if !os(macOS)

import SwiftUI

struct MultipleChoiceView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
        
    var body: some View {
        ForEach(viewModel.options.indices, id: \.self) { optionIndex in
            Button(action: { viewModel.selectStep(optionIndex: optionIndex) }, label: {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: (surveyViewModel.currentItemResponse?.responseMultipleChoice?.contains(viewModel.options[optionIndex].identifier) ?? false) ? "circle.fill" : "circle").font(.callout)
                            .foregroundColor(Color(.systemGray2))
                        Text(viewModel.options[optionIndex].label)
                            .font(.callout)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }.padding(.leading, 8)
                .padding(.trailing)
                .padding(.vertical, 12)
                .background(Color((surveyViewModel.currentItemResponse?.responseMultipleChoice?.contains(viewModel.options[optionIndex].identifier) ?? false) ? .systemGray3 : .systemGray5))
                .cornerRadius(6)
                .padding(.bottom, 4)
            })
        }
    }
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        private var itemToRender: MultipleChoiceSurveyItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel
        
        // Compute the ordinal scale steps for this question
        var options: [MultipleChoiceOption] {
            return itemToRender.multipleChoiceOptions
        }
        
        init(itemToRender: MultipleChoiceSurveyItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
        }
        
        // User tapped on one item
        func selectStep(optionIndex: Int) {
            if getIsSelected(optionIndex: optionIndex) {
                // If the new selection is already selected, toggle it
                surveyViewModel.currentItemResponse?.responseMultipleChoice?.removeAll(where: { $0 == options[optionIndex].identifier })
            } else {
                // Otherwise, update the item response to reflect the current selection
                surveyViewModel.currentItemResponse?.responseMultipleChoice?.append(options[optionIndex].identifier)
            }
            // Notify the view that changes occurred
            objectWillChange.send()
            surveyViewModel.objectWillChange.send()
        }
        
        // Returns whether an option at a given index is selected
        func getIsSelected(optionIndex: Int) -> Bool {
            guard let currentMCResponse = surveyViewModel.currentItemResponse?.responseMultipleChoice else {
                return false
            }
            return currentMCResponse.contains(options[optionIndex].identifier)
        }
    }
}

#endif
