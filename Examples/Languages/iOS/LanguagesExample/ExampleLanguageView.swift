//  ExampleLanguageView.swift
//  LanguagesExample
//

import SwiftUI

struct ExampleLanguageView: View {
    
    @ObservedObject private var viewModel = ExampleLanguageViewModel()
    
    var body: some View {
        List {
            Section("Keyboard status") {
                HStack(alignment: .center, spacing: 16) {
                    Circle()
                        .frame(width: 14)
                        .foregroundColor(kbInstalled ? .green : .red)
                        .padding(.top, 4)
                    
                    Text(kbInstalled ? "Installed" : "Not installed")
                }
                if kbInstalled {
                    HStack(alignment: .center, spacing: 16) {
                        Circle()
                            .frame(width: 14)
                            .foregroundColor(kbFullAccessGranted ? .green : .red)
                            .padding(.top, 4)
                        
                        Text(kbFullAccessGranted ? "Full access granted" : "Full access not granted")
                    }
                }
            }
            
            Section {
                ForEach(viewModel.enabledLanguages, id: \.self.locale) {
                    Text("\($0.locale) (\($0.layout.isEmpty ? "default layout" : $0.layout))")
                }
                if !viewModel.isExampleLocaleEnabled {
                    Button("Enable \(ExampleLanguageViewModel.exampleLocale) language") {
                        viewModel.onAddExampleLanguage()
                    }
                }
            } header: {
                Text("Enabled languages")
            } footer: {
                Text("The added languages are fetched with ")
                + Text("FleksyManagedSettings.userLanguages")
                    .monospacedIfAvailable()
                + Text(". Enabling a language does not mean that it is available. The language must be downloaded.")
            }
            
            Section {
                switch viewModel.status {
                case .downloaded:
                    NavigationLink("Change layout for \(ExampleLanguageViewModel.exampleLocale)", destination: LanguageLayoutSelectionView(viewModel: viewModel))
                    Button("Delete \(ExampleLanguageViewModel.exampleLocale)", role: .destructive) {
                        viewModel.onDeleteExampleLanguage()
                    }
                case .notDownloaded, .downloadError, .languageNotAvailable:
                    Button("Download \(ExampleLanguageViewModel.exampleLocale)") {
                        viewModel.onDownloadExampleLanguage()
                    }
                case .downloading(let progress):
                    ProgressView("Downloading language", value: progress)
                }
            }
        }
        .alert(isPresented: viewModel.presentDownloadErrorAlert) {
            let title: String = {
                switch viewModel.status {
                case .downloadError:
                    return "An error ocurred when downloading \(ExampleLanguageViewModel.exampleLocale). Please, try again later"
                case .languageNotAvailable:
                    return "The language \(ExampleLanguageViewModel.exampleLocale) is not available to download"
                default:
                    return  ""
                }
            }()
            return Alert(title: Text(title))
        }
        .navigationTitle("Language Example")
        .onAppear {
            viewModel.refreshKeyboardState()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willEnterForegroundNotification), perform: { _ in
            viewModel.refreshKeyboardState()
        })
    }
    
    private var kbInstalled: Bool {
        viewModel.keyboardStatus.installed
    }
    
    private var kbFullAccessGranted: Bool {
        viewModel.keyboardStatus.fullAccess
    }
}

#Preview {
    ExampleLanguageView()
}

extension Text {
    func monospacedIfAvailable() -> Text {
        if #available(iOS 16.4, *) {
            return monospaced()
        } else {
            return self
        }
    }
}
