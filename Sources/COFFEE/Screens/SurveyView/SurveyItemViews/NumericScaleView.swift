//
//  OrdinalScaleView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 22.02.21.
//

#if !os(macOS)

import SwiftUI

struct NumericScaleView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
        
    var body: some View {
        ForEach(viewModel.steps.indices, id: \.self) { stepIndex in
            Button(action: { viewModel.selectStep(stepIndex: stepIndex) }, label: {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: "circle.fill").font(.callout)
                            .foregroundColor(viewModel.steps[stepIndex].color)
                        Text(viewModel.steps[stepIndex].label)
                            .font(.callout)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }.padding(.leading, 8)
                .padding(.trailing)
                .padding(.vertical, 12)
                .background(viewModel.getBackgroundColor(stepIndex: stepIndex))
                .cornerRadius(6)
                .padding(.bottom, 4)
            })
        }
    }
}

extension NumericScaleView {
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        private var itemToRender: NumericScaleItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel
        // Reference to the item response
        private var itemResponse: NumericScaleResponse?
                
        // Compute the ordinal scale steps for this question
        var steps: [NumericScaleStep] {
            return itemToRender.steps
        }
        
        init(itemToRender: NumericScaleItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
            self.itemResponse = surveyViewModel.currentItemResponse as? NumericScaleResponse
        }
        
        /// Action to perform when tapping on step at given index
        func selectStep(stepIndex: Int) {
            if let itemResponse = itemResponse {
                if itemResponse.value == steps[stepIndex].value {
                    // If the new selection is already selected, toggle it
                    itemResponse.value = nil
                } else {
                    // Otherwise, update the item response to reflect the current selection
                    itemResponse.value = steps[stepIndex].value
                }
            }
            // Notify the view that changes occurred
            objectWillChange.send()
            surveyViewModel.objectWillChange.send()
        }
        
        /// Return background color of step row at given index
        func getBackgroundColor(stepIndex: Int) -> Color {
            guard let currentItemResponse = surveyViewModel.currentItemResponse as? NumericScaleResponse else {
                return Color(.systemGray5)
            }
            return Color(currentItemResponse.value == steps[stepIndex].value ? .systemGray3 : .systemGray5)
        }
    }
}

#endif
