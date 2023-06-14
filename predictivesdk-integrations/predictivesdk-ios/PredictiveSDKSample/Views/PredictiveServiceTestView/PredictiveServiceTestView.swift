//
//  PredictiveServiceTestView.swift
//  PredictiveSDKSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import SwiftUI

struct PredictiveServiceTestView: View {
    
    @ObservedObject private var viewModel: PredictiveServiceTestViewModel
    @FocusState private var focusTextField: Bool
    
    init(viewModel: PredictiveServiceTestViewModel) {
        self.viewModel = viewModel
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        VStack {
            Text("Predictive SDK Sample")
                .font(.title)
                .padding(16)
            
            VStack(spacing: 24) {
                PredictiveServiceTextField(text: self.$viewModel.textValue, placeHolder: "Enter text", selection: self.$viewModel.textSelection)
                    .focused(self.$focusTextField)
                    .frame(minHeight: 48)
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(.gray, lineWidth: 2))
                
                HStack(spacing: 48) {
                    Button("Autocorrect") {
                        self.focusTextField = false
                        self.viewModel.showAutoCorrectAction()
                    }
                    .font(.headline)
                    
                    Button("Suggestions") {
                        self.focusTextField = false
                        self.viewModel.showSuggestionsAction()
                    }
                    .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                
                if let errorMessage = self.viewModel.errorMessage {
                    Label("Error: \(errorMessage)", systemImage: Constants.Images.System.exclamationMarkCircleFill)
                        .foregroundColor(.red)
                }
            }
            .padding(16)
            
            if let buttonPressedText = self.viewModel.buttonPressed {
                VStack(alignment: .center, spacing: 0) {
                    Divider()
                    Text(buttonPressedText)
                        .font(.headline)
                        .padding()
                    
                    if !self.viewModel.candidates.isEmpty {
                        Divider()
                        List {
                            ForEach(values: self.viewModel.candidates) { candidate in
                                Button {
                                    self.viewModel.applyCandidate(candidate)
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(candidate.getCandidateType())
                                            .font(.footnote)
                                            .padding([.vertical], 4)
                                        ForEach(values: candidate.replacements) { replacement in
                                            HStack {
                                                Text("(\(replacement.start) - \(replacement.end))")
                                                    .font(.caption)
                                                Text(replacement.replacement)
                                            }
                                        }
                                    }
                                }
                                .foregroundColor(Color.primary)
                            }
                        }
                        Divider()
                    }
                }
            }
        }
        Spacer()
        Text(self.viewModel.localeLanguageVersion)
            .font(.footnote)
        Spacer()
    }
}


struct PredictiveServiceTestView_Previews: PreviewProvider {
    static var previews: some View {
        PredictiveServiceTestView(viewModel: PredictiveServiceTestViewModel())
    }
}
