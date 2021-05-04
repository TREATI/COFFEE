//
//  TextPickerView.swift
//  COFFEE
//
//  Created by Victor Prüfer on 02.03.21.
//

#if !os(macOS)

import SwiftUI
import CoreLocation
import Combine

struct LocationPickerView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var surveyViewModel: SurveyView.ViewModel
    
    var body: some View {
        VStack {
            Text("These coordinates will be shared:")
                .font(.caption)
                .foregroundColor(.secondary)
            VStack(alignment: .center, spacing: 4) {
                Text(viewModel.lastKnownLocation?.coordinate.latitude.description ?? "No coordinates available")
                    .font(.callout)
                    .foregroundColor(.primary)
                Text(viewModel.lastKnownLocation?.coordinate.longitude.description ?? "No coordinates available")
                    .font(.callout)
                    .foregroundColor(.primary)
            }
            .padding(6)
            
            // Button to go to next question
            Button(action: { viewModel.shareLocation() }, label: {
                HStack() {
                    Spacer()
                    Text(viewModel.hasSharedLocation ? "Location shared" : "Share Location")
                    if (viewModel.hasSharedLocation) {
                        Image(systemName: "checkmark")
                    }
                    Spacer()
                }
                .font(.headline)
                .foregroundColor(viewModel.hasSharedLocation ? .green : .white)
                .padding(.vertical, 10)
                .background(viewModel.hasSharedLocation ? Color(.systemGray5) : viewModel.shareButtonColor)
                .cornerRadius(8)
            }).disabled(viewModel.lastKnownLocation == nil)
        }.onAppear(perform: {
            viewModel.startUpdating()
        })
    }
    
    class ViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
        // The currently displayed survey question
        private var itemToRender: LocationPickerSurveyItem
        // Reference to the environment object, the survey view model
        private var surveyViewModel: SurveyView.ViewModel
        // Location manager to access the user's location
        private let manager: CLLocationManager
        
        var willChange = PassthroughSubject<ViewModel, Never>()
        
        @Published var lastKnownLocation: CLLocation? {
            willSet {
                willChange.send(self)
            }
        }
        
        @Published var hasSharedLocation: Bool = false
        
        // Return the color for the share button
        var shareButtonColor: Color {
            return surveyViewModel.surveyColor
        }
        
        init(itemToRender: LocationPickerSurveyItem, surveyViewModel: SurveyView.ViewModel) {
            self.itemToRender = itemToRender
            self.surveyViewModel = surveyViewModel
            self.manager = CLLocationManager()
            super.init()
        }
        
        func startUpdating() {
            self.manager.delegate = self
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingLocation()
        }
        
        func shareLocation() {
            guard let currentLocation = lastKnownLocation else {
                return
            }
            surveyViewModel.currentItemResponse?.responseLocationPickerLatitude = currentLocation.coordinate.latitude
            surveyViewModel.currentItemResponse?.responseLocationPickerLongitude = currentLocation.coordinate.longitude
            
            hasSharedLocation = true
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            lastKnownLocation = locations.last
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                manager.startUpdatingLocation()
            }
        }
    }
}

#endif
