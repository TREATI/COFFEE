//
//  SurveyOverviewScreen.swift
//  COFFEE
//
//  Created by Victor Prüfer on 21.02.21.
//

#if !os(macOS)

import SwiftUI

/// A screen that shows details of a given survey and allows the user to start it.
public struct SurveyOverviewScreen: View {
    
    /// The survey to display
    public var survey: Survey
    /// A completion handler that is called after the respondent completes the survey
    public var completionHandler: ((Submission) -> ())?
    
    public init(survey: Survey, completionHandler: ((Submission) -> ())?) {
        self.survey = survey
        self.completionHandler = completionHandler
    }
    
    // Temporary placeholder for reminder toggle
    @State var isOn: Bool = true
    
    // Whether the survey is shown in presentation mode
    @State var showSurvey: Bool = false
    
    // Formatter for the date
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    public var body: some View {
        VStack(alignment: .leading) {
            // Stack for upper part (title + info scrollview)
            VStack(alignment: .leading, spacing: 12) {
                // Styled title bar
                Text(survey.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(3)
                    .padding(.top, 90)
                    .padding(.bottom, 8)
                    .padding(.horizontal)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor.init(hexString: survey.color).lighter()), Color(UIColor.init(hexString: survey.color).darker(by: 10))]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.75, y: 1)))

                // Scrollview with information about survey
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        // General information headline
                        Text("General Information".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        // Research conductor
                        if let researcher = survey.researcher {
                            HStack {
                                Image(systemName: "person")
                                    .frame(width: 30)
                                Text(researcher.name)
                            }.padding(.horizontal)
                        }
                        
                        // Timespan of the survey
                        HStack(alignment: .top) {
                            Image(systemName: "calendar")
                                .padding(.vertical, 3)
                                .frame(width: 30)
                            VStack(alignment: .leading, spacing: 4, content: {
                                Text("Starts on \(dateFormatter.string(from: survey.startDate))")
                                Text("Ends on \(dateFormatter.string(from: survey.endDate))")
                            })
                        }.padding(.horizontal)
                        
                        // Number of times you can submit to this survey
                        HStack {
                            Image(systemName: "list.number")
                                .frame(width: 30)
                            Text(survey.allowsMultipleSubmissions ? "You can submit multiple times" : "You can submit only once")
                        }.padding(.horizontal)
                        
                        // Description headline
                        Text("Description".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding([.horizontal, .top])
                        
                        // Description of the survey if available
                        Text(survey.description)
                            .padding(.horizontal)
                        
                        // Reminders section
                        if !survey.reminders.isEmpty {
                            Text("Reminders".uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding([.horizontal, .top])
                            
                            // When to take this survey / reminders for this survey
                            VStack(alignment: .leading, spacing: 8, content: {
                                ForEach(survey.reminders.indices, id: \.self) { index in
                                    Toggle(isOn: $isOn, label: {
                                        switch survey.reminders[index].type {
                                            case .dateTime:
                                                Image(systemName: "calendar")
                                            case .interval:
                                                Image(systemName: "repeat")
                                            case .locationChange:
                                                Image(systemName: "location")
                                        }
                                        Text(survey.reminders[index].description)
                                    })
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(6)
                                }
                            }).padding(.horizontal)
                        }
                    }
                }
            }
            .font(.body).foregroundColor(.primary)
            .ignoresSafeArea(edges: .top)
            
            Spacer()
            
            // Lower part: button to start the survey in case the survey is valid
            if let takeSurveyViewModel = TakeSurveyScreen.ViewModel(survey: survey, completionHandler: completionHandler, showSurvey: $showSurvey) {
                NavigationLink(
                    destination: TakeSurveyScreen(viewModel: takeSurveyViewModel),
                    isActive: $showSurvey,
                    label: {
                        HStack() {
                            Spacer()
                            Text("Start now")
                            Image(systemName: "chevron.right")
                            Spacer()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .background(Color(UIColor.init(hexString: survey.color)))
                        .cornerRadius(8)
                        .padding()
                    })
            }
            
        }
        .navigationBarTitle("")
    }
}

#endif
