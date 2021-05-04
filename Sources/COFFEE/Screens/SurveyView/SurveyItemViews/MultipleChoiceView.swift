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
                        Image(systemName: viewModel.getImage(optionIndex: optionIndex)).font(.callout)
                            .foregroundColor(Color(.systemGray2))
                        Text(viewModel.options[optionIndex].label)
                            .font(.callout)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }.padding(.leading, 8)
                .padding(.trailing)
                .padding(.vertical, 12)
                .background(viewModel.getBackgroundColor(optionIndex: optionIndex))
                .cornerRadius(6)
                .padding(.bottom, 4)
            })
        }
    }
}

extension MultipleChoiceView {
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        private var itemToRender: MultipleChoiceItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel
        // Reference to the item response
        private var itemResponse: MultipleChoiceResponse?
        
        // Compute the ordinal scale steps for this question
        var options: [MultipleChoiceOption] {
            return itemToRender.multipleChoiceOptions
        }
        
        init(itemToRender: MultipleChoiceItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
            self.itemResponse = surveyViewModel.currentItemResponse as? MultipleChoiceResponse
        }
        
        /// Action when user tapped at option row at given index
        func selectStep(optionIndex: Int) {
            if getIsSelected(optionIndex: optionIndex) {
                // If the new selection is already selected, toggle it
                itemResponse?.value.removeAll(where: { $0 == options[optionIndex].identifier })
            } else {
                // Otherwise, update the item response to reflect the current selection
                itemResponse?.value.append(options[optionIndex].identifier)
            }
            
            // Notify the view that changes occurred
            objectWillChange.send()
            surveyViewModel.objectWillChange.send()
        }
        
        /// Returns whether an option at a given index is selected or not
        func getIsSelected(optionIndex: Int) -> Bool {
            guard let currentItemResponse = surveyViewModel.currentItemResponse as? MultipleChoiceResponse else {
                return false
            }
            return currentItemResponse.value.contains(options[optionIndex].identifier)
        }
        
        /// Returns the background color for an option row at a given index
        func getBackgroundColor(optionIndex: Int) -> Color {
            return Color(getIsSelected(optionIndex: optionIndex) ? .systemGray3 : .systemGray5)
        }
        
        /// Returns the image name for an option row at a given index
        func getImage(optionIndex: Int) -> String {
            return getIsSelected(optionIndex: optionIndex) ? "circle.fill" : "circle"
        }
    }
}

#endif
