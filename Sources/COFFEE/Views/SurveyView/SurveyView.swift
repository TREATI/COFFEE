//
//  SurveyView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 22.02.21.
//

import SwiftUI

#if !os(macOS)

/// A screen presenting a given survey
public struct SurveyView: View {
    
    // View model for this survey session, also provided to the subviews as environment object
    @ObservedObject public var viewModel: ViewModel
    
    public init(viewModel: SurveyView.ViewModel) {
        self.viewModel = viewModel
    }
            
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Progress indicator
            ProgressView(value: Double(viewModel.currentSurveyItemIndex + 1), total: Double(viewModel.survey.items.count), label: {
                Text("Question \(viewModel.currentSurveyItemIndex + 1) of \(viewModel.survey.items.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            })
            .progressViewStyle(LinearProgressViewStyle(tint: viewModel.surveyColor))
            .padding()
            
            // The rendered item view, depending on the current survey item's type
            SurveyItemView().environmentObject(viewModel)
                        
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
    }
}

public extension SurveyView {
    
    class ViewModel: ObservableObject {
        // The survey to take
        let survey: Survey
        // Completion handler that is called once the response is submitted
        private var completionHandler: ((Submission) -> ())?
        
        // Index of the currently displayed survey item
        @Published private(set) var currentSurveyItemIndex: Int = 0
        
        // The currently displayed survey item
        @Published var currentSurveyItem: SurveyItem
        // Whether there is a next survey item
        @Published var isNextSurveyItemAvailable: Bool
        
        // Whether the survey screen where the user can respond should be shown
        @Binding var showSurvey: Bool
                
        // Compute the background color for the continue button
        var nextButtonColor: Color {
            if isNextSurveyItemAvailable {
                return survey.color.opacity(isContinueAllowed ? 1.0 : 0.6)
            } else {
                return Color.green.opacity(isContinueAllowed ? 1.0 : 0.6)
            }
        }
        
        // Return the color for the progress indicator
        var surveyColor: Color {
            return survey.color
        }
        
        // Compute whether continueing is allowed
        var isContinueAllowed: Bool {
            return !currentSurveyItem.isMandatory || currentSurveyItem.isResponseValid == true
        }
        
        /// Default initializer for the `SurveyView`'s view model
        /// - Parameters:
        ///   - survey: The survey to display
        ///   - completionHandler: A function that is called when the survey is completed
        ///   - showSurvey: A binding to a boolean value that defines whether the survey view is shown or not
        public init(survey: Survey, completionHandler: ((Submission) -> ())?, showSurvey: Binding<Bool>) {
            // Ensure the survey is not empty
            assert(!survey.items.isEmpty, "Survey is empty. The survey should have at least one item.")

            self.survey = survey
            self.completionHandler = completionHandler
            self.currentSurveyItem = survey.items.first!
            self.isNextSurveyItemAvailable = survey.items.count > 1
            self._showSurvey = showSurvey
        }
        
        // This will open the next survey item if available
        func showNextSurveyItem() {
            guard isContinueAllowed else {
                return
            }
           
            // Check if there is an next item to show
            guard isNextSurveyItemAvailable else {
                // No more items, survey response is complete
                
                // Create submission and return it trough completion handler
                let responseObjects = survey.items.compactMap({ $0.generateResponseObject() })
                let submission = Submission(submissionDate: Date(), responses: responseObjects)
                completionHandler?(submission)
                
                // Go back to overview screen
                showSurvey = false
                
                return
            }
            
            // Continue with next survey item, reset response
            currentSurveyItemIndex += 1
            currentSurveyItem = survey.items[currentSurveyItemIndex]
            isNextSurveyItemAvailable = (survey.items.count - 1) > currentSurveyItemIndex
        }
    }
}

#endif
