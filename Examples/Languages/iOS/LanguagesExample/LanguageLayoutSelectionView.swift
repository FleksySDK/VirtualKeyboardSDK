//  LanguageLayoutSelectionView.swift
//  LanguagesExample
//

import SwiftUI

struct LanguageLayoutSelectionView: View {
    
    @ObservedObject var viewModel: ExampleLanguageViewModel
    
    var body: some View {
        Group {
            if viewModel.loadingLayoutOptions {
                ProgressView()
            } else {
                List {
                    Section("Select layout for \(ExampleLanguageViewModel.exampleLocale)") {
                        ForEach(viewModel.layoutOptionsForExampleLocale, id: \.self) { layout in
                            Button(action: {
                                viewModel.onSelectLayout(layout)
                            }, label: {
                                HStack {
                                    Text(layout)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .opacity(layout == viewModel.selectedLayout ? 1 : 0)
                                }
                            })
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.onFetchLayoutOptionsForExampleLanguage()
        })
    }
}


#Preview {
    LanguageLayoutSelectionView(viewModel: .init())
}
