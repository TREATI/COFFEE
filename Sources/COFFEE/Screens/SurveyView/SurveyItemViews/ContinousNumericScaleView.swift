//
//  ContinousNumericScaleView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 22.02.21.
//

#if !os(macOS)

import SwiftUI
import Sliders

struct ContinousNumericScaleView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text(viewModel.numberFormatter.string(for: viewModel.currentSliderValue) ?? "Invalid input")
                .font(.title)
                .padding(4)
            Text(viewModel.nearestStep?.label ?? "No label")
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(4)
                .padding(4)
            
            ValueSlider(value: $viewModel.currentSliderValue, in: viewModel.scaleRange)
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

extension ContinousNumericScaleView {
    
    class ViewModel: ObservableObject {
        // The currently displayed survey question
        private var itemToRender: NumericScaleItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel
        // Reference to the item response
        private var itemResponse: NumericScaleResponse?
        
        var numberFormatter: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            return numberFormatter
        }()
        
        // Binding to the slider, defining the current value in range 0 to 1
        @Published var currentSliderValue: Double = 0 {
            didSet {
                itemResponse?.value = currentSliderValue
            }
        }
        
        // Compute the ordinal scale steps for this question
        var steps: [NumericScaleStep] {
            return itemToRender.steps.sorted(by: { $0.value < $1.value })
        }
        
        // The value range of the scale (from min to max)
        var scaleRange: ClosedRange<Double> {
            return (steps.map({ $0.value }).min() ?? 0)...(steps.map({ $0.value }).max() ?? 1)
        }
        
        // Compute the colors for the slider gradient
        var sliderGradientColors: [Color] {
            return steps.map({ $0.color })
        }
        
        // The step that the current slider position is nearest to
        var nearestStep: NumericScaleStep? {
            return steps.map({ (difference: currentSliderValue - $0.value, step: $0) }).min { (a, b) -> Bool in
                return abs(a.difference) < abs(b.difference)
            }?.step
        }
        
        init(itemToRender: NumericScaleItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
            self.itemResponse = surveyViewModel.currentItemResponse as? NumericScaleResponse
        }
    }
}

#endif
