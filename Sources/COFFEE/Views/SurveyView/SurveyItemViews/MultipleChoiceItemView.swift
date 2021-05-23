//
//  MultipleChoiceItemView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 02.03.21.
//

#if !os(macOS)

import SwiftUI

struct MultipleChoiceItemView: View {
    
    @ObservedObject var viewModel: ViewModel
            
    var body: some View {
        ForEach(viewModel.options.indices, id: \.self) { optionIndex in
            Button(action: { viewModel.selectStep(optionIndex: optionIndex) }, label: {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: viewModel.getIcon(optionIndex: optionIndex)).font(.callout)
                            .foregroundColor(viewModel.getIconColor(optionIndex: optionIndex))
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

extension MultipleChoiceItemView {
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        private var itemToRender: MultipleChoiceItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel
        
        // Compute the ordinal scale steps for this question
        var options: [MultipleChoiceItem.Option] {
            if itemToRender.isAscendingOrder {
                return itemToRender.options.sorted(by: { $0.identifier < $1.identifier })
            }
            return itemToRender.options.sorted(by: { $0.identifier > $1.identifier })
        }
        
        init(itemToRender: MultipleChoiceItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
        }
        
        /// Action when user tapped at option row at given index
        func selectStep(optionIndex: Int) {
            if getIsSelected(optionIndex: optionIndex) {
                // If the new selection is already selected, toggle it
                itemToRender.currentResponse.removeAll(where: { $0 == options[optionIndex].identifier })
            } else {
                // Otherwise, update the item response to reflect the current selection
                // If single choice, deselect previos selection
                if itemToRender.minNumberOfSelections == 1 && itemToRender.maxNumberOfSelections == 1 {
                    itemToRender.currentResponse.removeAll()
                }
                itemToRender.currentResponse.append(options[optionIndex].identifier)
            }
            
            // Notify the view that changes occurred
            objectWillChange.send()
            surveyViewModel.objectWillChange.send()
        }
        
        /// Returns whether an option at a given index is selected or not
        func getIsSelected(optionIndex: Int) -> Bool {
            return itemToRender.currentResponse.contains(options[optionIndex].identifier)
        }
        
        /// Returns the background color for an option row at a given index
        func getBackgroundColor(optionIndex: Int) -> Color {
            return Color(getIsSelected(optionIndex: optionIndex) ? .systemGray3 : .systemGray5)
        }
        
        /// Returns the image name for an option row at a given index
        func getIcon(optionIndex: Int) -> String {
            if options[optionIndex].color != nil {
                return "circle.fill"
            }
            return getIsSelected(optionIndex: optionIndex) ? "circle.fill" : "circle"
        }
        
        /// Returns the color for the icon for an option row at a given index
        func getIconColor(optionIndex: Int) -> Color {
            return options[optionIndex].color ?? Color(.systemGray2)
        }
    }
}

#endif
