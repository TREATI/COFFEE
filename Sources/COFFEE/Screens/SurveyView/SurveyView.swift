//
//  SurveyView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 22.02.21.
//

import SwiftUI

#if !os(macOS)

/// A screen presenting a given survey
struct SurveyView: View {
    
    // View model for this survey session, also provided to the subviews as environment object
    @StateObject var viewModel: ViewModel
            
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Progress indicator
            ProgressView(value: Double(viewModel.currentSurveyItemIndex + 1), total: Double(viewModel.numberOfSurveyItems), label: {
                Text("\(viewModel.currentSurveyItemIndex) of \(viewModel.numberOfSurveyItems) questions completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            })
            .progressViewStyle(LinearProgressViewStyle(tint: viewModel.surveyColor))
            .padding()
            
            // The rendered item view, depending on the current survey item's type
            SurveyItemView(currentItem: viewModel.currentSurveyItem)
            
            // Button to go to next question
            Button(action: { viewModel.showNextSurveyItem() }, label: {
                HStack() {
                    Spacer()
                    Text(viewModel.isNextSurveyItemAvailable ? "Next" : "Submit")
                    if (viewModel.isNextSurveyItemAvailable) {
                        Image(systemName: "chevron.right")
                    }
                    Spacer()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .background(viewModel.nextButtonColor)
                .cornerRadius(8)
                .padding()
            }).disabled(!viewModel.isContinueAllowed)
        }
        .navigationBarTitle("Question \(viewModel.currentSurveyItemIndex + 1)", displayMode: .inline)
        .environmentObject(viewModel)
    }
}

extension SurveyView {
    
    class ViewModel: ObservableObject {
        // The survey to take
        private let survey: Survey
        // The responses to the survey items
        private var itemResponses: [ItemResponse] = []
        // Completion handler that is called once the response is submitted
        private var completionHandler: ((Submission) -> ())?
        
        // Index of the currently displayed survey item
        @Published private(set) var currentSurveyItemIndex: Int = 0
        // Percentage of completed questions for progress indicator
        @Published private(set) var numberOfSurveyItems: Int
        
        // The currently displayed survey item
        @Published var currentSurveyItem: SurveyItem
        // The response item for the current question
        @Published var currentItemResponse: ItemResponse?
        // Whether there is a next survey item
        @Published var isNextSurveyItemAvailable: Bool
        
        // Whether the survey screen where the user can respond should be shown
        @Binding var showSurvey: Bool
                
        // Compute the background color for the continue button
        var nextButtonColor: Color {
            if isNextSurveyItemAvailable {
                return Color(UIColor.init(hexString: survey.color)).opacity(isContinueAllowed ? 1.0 : 0.6)
            } else {
                return (Color.green.opacity(isContinueAllowed ? 1.0 : 0.6))
            }
        }
        
        // Return the color for the progress indicator
        var surveyColor: Color {
            return Color(UIColor.init(hexString: survey.color))
        }
        
        // Compute whether continueing is allowed
        var isContinueAllowed: Bool {
            return currentSurveyItem.isOptional || currentItemResponse?.isValidInput == true
        }
        
        init?(survey: Survey, completionHandler: ((Submission) -> ())?, showSurvey: Binding<Bool>) {
            // Make sure survey is not empty
            guard let firstItem = survey.items.first else {
                return nil
            }
            self.survey = survey
            self.completionHandler = completionHandler
            self.numberOfSurveyItems = survey.items.count
            self.currentSurveyItem = firstItem
            self.isNextSurveyItemAvailable = survey.items.count > 1
            self._showSurvey = showSurvey
            
            prepareItemResponse()
        }
        
        // This will open the next survey item if available
        func showNextSurveyItem() {
            guard isContinueAllowed else {
                return
            }
            // Submit item response if input is valid
            if let currentItemResponse = currentItemResponse, currentItemResponse.isValidInput {
                itemResponses.append(currentItemResponse)
            }
                        
            // Check if there is an next item to show
            guard isNextSurveyItemAvailable else {
                // No more items, survey response is complete
                
                // Create submission and return it trough completion handler
                let submission = Submission(submissionDate: Date(), responses: itemResponses)
                completionHandler?(submission)
                
                // Go back to overview screen
                showSurvey = false
                
                return
            }
            
            // Continue with next survey item, reset response
            currentSurveyItemIndex += 1
            currentSurveyItem = survey.items[currentSurveyItemIndex]
            isNextSurveyItemAvailable = (survey.items.count - 1) > currentSurveyItemIndex
            
            prepareItemResponse()
        }
        
        // Setup the initial item response for a new survey item
        func prepareItemResponse() {
            currentItemResponse = ItemResponse(type: currentSurveyItem.type, surveyItemID: currentSurveyItem.identifier)
            if currentSurveyItem.type == .multipleChoice {
                currentItemResponse?.responseMultipleChoice = [Int]()
            }
            if currentSurveyItem.type == .numericScale,
               let ordinalScaleItem = currentSurveyItem as? NumericScaleItem,
               ordinalScaleItem.isScaleContinous == true {
                currentItemResponse?.responseOrdinalScale = 0
            }
        }
    }
}

#endif
