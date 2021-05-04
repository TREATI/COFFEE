//
//  NominalScaleView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 01.03.21.
//

#if !os(macOS)

import SwiftUI
/*
struct NominalScaleView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
        
    var body: some View {
        ForEach(viewModel.steps.indices, id: \.self) { stepIndex in
            Button(action: { viewModel.selectStep(stepIndex: stepIndex) }, label: {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: surveyViewModel.currentItemResponse?.responseNominalScale == viewModel.steps[stepIndex].identifier ? "circle.fill" : "circle").font(.callout)
                            .foregroundColor(Color(.systemGray2))
                        Text(viewModel.steps[stepIndex].label)
                            .font(.callout)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }.padding(.leading, 8)
                .padding(.trailing)
                .padding(.vertical, 12)
                .background(Color(surveyViewModel.currentItemResponse?.responseNominalScale == viewModel.steps[stepIndex].identifier ? .systemGray3 : .systemGray5))
                .cornerRadius(6)
                .padding(.bottom, 4)
            })
        }
    }
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        private var itemToRender: NominalScaleSurveyItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel
        
        // Compute the ordinal scale steps for this question
        var steps: [NominalScaleStep] {
            return itemToRender.nominalScaleSteps
        }
        
        init(itemToRender: NominalScaleSurveyItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
        }
        
        // User tapped on one item
        func selectStep(stepIndex: Int) {
            if surveyViewModel.currentItemResponse?.responseNominalScale == steps[stepIndex].identifier {
                // If the new selection is already selected, toggle it
                surveyViewModel.currentItemResponse?.responseNominalScale = nil
            } else {
                // Otherwise, update the item response to reflect the current selection
                surveyViewModel.currentItemResponse?.responseNominalScale = steps[stepIndex].identifier
            }
            // Notify the view that changes occurred
            objectWillChange.send()
            surveyViewModel.objectWillChange.send()
        }
    }
}
*/
#endif
