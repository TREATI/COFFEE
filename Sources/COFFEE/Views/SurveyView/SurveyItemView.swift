//
//  SurveyItemView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 23.02.21.
//

#if !os(macOS)

import SwiftUI

/// A container view that displays a given survey item in the correct visual appearance
struct SurveyItemView: View {
    
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
    
    var descriptionText: String? {
        guard var tempDescription = surveyViewModel.currentSurveyItem.description else {
            return nil
        }
        if !surveyViewModel.currentSurveyItem.isMandatory {
            tempDescription += " – You can skip this question"
        }
        return tempDescription
    }
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // The question of the displayed survey item
                Text(surveyViewModel.currentSurveyItem.question)
                    .font(.headline)
                    .padding(.top)
                    .padding(.bottom, 4)
                    .padding(.horizontal)
            
                // Question type description, bottom-aligned
                if let descriptionText = descriptionText {
                    Label(descriptionText, systemImage: "info.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
                
                // The rendered input view, depending on the survey item type
                Group {
                    switch surveyViewModel.currentSurveyItem.type {
                        case .slider:
                            if let sliderItem = surveyViewModel.currentSurveyItem as? SliderItem {
                                SliderItemView(viewModel: SliderItemView.ViewModel(itemToRender: sliderItem, surveyViewModel: surveyViewModel))
                            }
                        case .multipleChoice:
                            if let multipleChoiceItem = surveyViewModel.currentSurveyItem as? MultipleChoiceItem {
                                MultipleChoiceItemView(viewModel: MultipleChoiceItemView.ViewModel(itemToRender: multipleChoiceItem, surveyViewModel: surveyViewModel))
                            }
                        case .text:
                            if let textInputItem = surveyViewModel.currentSurveyItem as? TextItem {
                                TextItemView(viewModel: TextItemView.ViewModel(itemToRender: textInputItem))
                            }
                        case .locationPicker:
                            if let locationPickerItem = surveyViewModel.currentSurveyItem as? LocationPickerItem {
                                LocationPickerView(viewModel: LocationPickerView.ViewModel(itemToRender: locationPickerItem, surveyViewModel: surveyViewModel))
                            }
                        case .number:
                            if let numberItem = surveyViewModel.currentSurveyItem as? NumberItem {
                                NumberItemView(viewModel: NumberItemView.ViewModel(itemToRender: numberItem))
                            }
                    }
                }.padding(.horizontal)
                                
                // Spacer to make view full width and top-aligned
                HStack() {
                    Spacer()
                }
                Spacer()
            }
        }.background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

#endif
