//
//  SliderItemView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 06.05.21.
//

#if !os(macOS)

import SwiftUI
import Sliders

struct SliderItemView: View {
    
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            if (viewModel.itemToRender.showSliderValue) {
                Text(viewModel.numberFormatter.string(for: viewModel.itemToRender.currentResponse) ?? "Invalid input")
                    .font(.callout)
                    .padding(4)
            }
            Text(viewModel.nearestStep?.label ?? "No label")
                .font(.title)
                .foregroundColor(.secondary)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(4)
                .padding(4)
            
            ValueSlider(value: $viewModel.itemToRender.currentResponse, in: viewModel.scaleRange, step: viewModel.itemToRender.isContinuous ? 0.01 : 1)
                .onChange(of: viewModel.itemToRender.currentResponse, perform: { value in
                    surveyViewModel.objectWillChange.send()
                })
                .valueSliderStyle(
                    HorizontalValueSliderStyle(
                        track: LinearGradient(
                            gradient: Gradient(colors: viewModel.sliderGradientColors),
                            startPoint: .leading, endPoint: .trailing
                        )
                        .frame(height: 8)
                        .cornerRadius(3),
                        thumbSize: CGSize(width: 10, height: 36)
                    )
                )
            
            Spacer()
        }
    }
}

extension SliderItemView {
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        @Published var itemToRender: SliderItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel

        var numberFormatter: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            return numberFormatter
        }()
        
        // Compute the ordinal scale steps for this question
        var steps: [SliderItem.Step] {
            return itemToRender.steps.sorted(by: { $0.value < $1.value })
        }
        
        // The value range of the scale (from min to max)
        var scaleRange: ClosedRange<Double> {
            return (steps.map({ $0.value }).min() ?? 0)...(steps.map({ $0.value }).max() ?? 1)
        }
        
        // Compute the colors for the slider gradient
        var sliderGradientColors: [Color] {
            return itemToRender.isColored ? steps.compactMap({ $0.color }) : [Color(.systemGray2)]
        }
        
        // The step that the current slider position is nearest to
        var nearestStep: SliderItem.Step? {
            return steps.map({ (difference: itemToRender.currentResponse - $0.value, step: $0) }).min { (a, b) -> Bool in
                return abs(a.difference) < abs(b.difference)
            }?.step
        }
        
        init(itemToRender: SliderItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
        }
    }
}

#endif
