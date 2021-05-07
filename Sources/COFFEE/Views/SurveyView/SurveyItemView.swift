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
    
    var currentItem: SurveyItem
    
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
    
    var descriptionText: String {
        var tempDescription = currentItem.description
        if !currentItem.isMandatory {
            tempDescription += " – You can skip this question"
        }
        return tempDescription
    }
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // The question of the displayed survey item
                Text(currentItem.question)
                    .font(.headline)
                    .padding(.top)
                    .padding(.bottom, 4)
                    .padding(.horizontal)
                
                // Question type description, bottom-aligned
                Label(descriptionText, systemImage: "info.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                // The rendered input view, depending on the survey item type
                Group {
                    switch currentItem.type {
                        case .slider:
                            if let sliderItem = currentItem as? SliderItem {
                                SliderItemView(viewModel: SliderItemView.ViewModel(itemToRender: sliderItem, surveyViewModel: surveyViewModel))
                            }
                        case .multipleChoice:
                            if let multipleChoiceItem = currentItem as? MultipleChoiceItem {
                                MultipleChoiceItemView(viewModel: MultipleChoiceItemView.ViewModel(itemToRender: multipleChoiceItem, surveyViewModel: surveyViewModel))
                            }
                        case .text:
                            if let textInputItem = currentItem as? TextItem {
                                TextItemView(viewModel: TextItemView.ViewModel(itemToRender: textInputItem, surveyViewModel: surveyViewModel))
                            }
                        case .locationPicker:
                            if let locationPickerItem = currentItem as? LocationPickerItem {
                                LocationPickerView(viewModel: LocationPickerView.ViewModel(itemToRender: locationPickerItem, surveyViewModel: surveyViewModel))
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
