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
    @StateObject var viewModel: ViewModel
    
    public init(viewModel: SurveyView.ViewModel) {
        self.viewModel = viewModel
    }
            
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Progress indicator
            ProgressView(value: Double(viewModel.currentSurveyItemIndex + 1), total: Double(viewModel.numberOfSurveyItems), label: {
                Text("Question \(viewModel.currentSurveyItemIndex + 1) of \(viewModel.numberOfSurveyItems)")
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
    
    public class ViewModel: ObservableObject {
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
            return !currentSurveyItem.isMandatory || currentItemResponse?.isValidInput == true
        }
        
        /// Default initializer for the `SurveyView`'s view model
        /// - Parameters:
        ///   - survey: The survey to display
        ///   - completionHandler: A function that is called when the survey is completed
        ///   - showSurvey: A binding to a boolean value that defines whether the survey view is shown or not
        public init(survey: Survey, completionHandler: ((Submission) -> ())?, showSurvey: Binding<Bool>) {
            // Make sure survey is not empty
            // Ensure the survey is not empty
            assert(!survey.items.isEmpty, "Survey is empty. The survey should have at least one item.")

            self.survey = survey
            self.completionHandler = completionHandler
            self.numberOfSurveyItems = survey.items.count
            self.currentSurveyItem = survey.items.first!
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
            switch currentSurveyItem.type {
                case .slider:
                    if let currentSurveyItem = currentSurveyItem as? SliderItem {
                        if currentSurveyItem.isContinuous {
                            // For continous scales, center slider position
                            let scaleRangeMax = currentSurveyItem.steps.max(by: { $0.value < $1.value })?.value ?? 1
                            let scaleRangeMin = currentSurveyItem.steps.min(by: { $0.value < $1.value })?.value ?? -1
                            let scaleRangeCenter = (Double(scaleRangeMax) - abs(Double(scaleRangeMin))) / 2.0
                            currentItemResponse = SliderResponse(itemIdentifier: currentSurveyItem.identifier, initialValue: scaleRangeCenter)
                        } else {
                            // For discrete scales, select middle position
                            let middleIndex = (currentSurveyItem.steps.count > 1 ? currentSurveyItem.steps.count - 1 : currentSurveyItem.steps.count) / 2
                            currentItemResponse = SliderResponse(itemIdentifier: currentSurveyItem.identifier, initialValue: currentSurveyItem.steps[middleIndex].value)
                        }
                    }
                case .multipleChoice:
                    if let currentSurveyItem = currentSurveyItem as? MultipleChoiceItem {
                        currentItemResponse = MultipleChoiceResponse(itemIdentifier: currentSurveyItem.identifier, minNumberOfSelections: currentSurveyItem.minNumberOfSelections, maxNumberOfSelections: currentSurveyItem.maxNumberOfSelections)
                    }
                case .text:
                    currentItemResponse = TextResponse(itemIdentifier: currentSurveyItem.identifier)
                case .locationPicker:
                    currentItemResponse = LocationPickerResponse(itemIdentifier: currentSurveyItem.identifier)
            }
        }
    }
}

#endif
