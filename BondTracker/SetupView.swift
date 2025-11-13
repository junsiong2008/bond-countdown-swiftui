// SetupView.swift
import SwiftUI

struct SetupView: View {
    @EnvironmentObject var dataStore: BondDataStore
    @Environment(\.dismiss) var dismiss
    
    @State private var totalBondAmount: String = ""
    @State private var totalServiceDays: String = ""
    @State private var startDate = Date()
    @State private var showError = false
    @State private var errorMessage = ""
    @FocusState var isInputActive: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bond Details")) {
                    HStack {
                        Text("$")
                        TextField("Total Bond Amount", text: $totalBondAmount)
#if canImport(UIKit)
                            .keyboardType(UIKeyboardType.decimalPad)
                            .focused($isInputActive)
                         
                          
#endif
                    }
                    
                    TextField("Total Service Days", text: $totalServiceDays)
#if canImport(UIKit)
                        .keyboardType(UIKeyboardType.numberPad)
                        .focused($isInputActive)
                      
#endif
                }
                
                Section(header: Text("Start Date")) {
                    DatePicker(
                        "Employment Start Date",
                        selection: $startDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                }
                
                Section {
                    Button(action: saveData) {
                        HStack {
                            Spacer()
                            Text("Save & Start Tracking")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
            }
            .toolbar { keyboardToolbar }
            .navigationTitle("Setup Bond Tracker")
#if os(iOS) || os(tvOS) || os(watchOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .alert("Invalid Input", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    @ToolbarContentBuilder
      private var keyboardToolbar: some ToolbarContent {
          ToolbarItemGroup(placement: .keyboard) {
              Spacer()
              Button("Done") {
                  isInputActive = false
              }
          }
      }
    
    private func saveData() {
        // Validate inputs
        guard let amount = Double(totalBondAmount), amount > 0 else {
            errorMessage = "Please enter a valid bond amount greater than 0"
            showError = true
            return
        }
        
        guard let days = Int(totalServiceDays), days > 0 else {
            errorMessage = "Please enter valid service days greater than 0"
            showError = true
            return
        }
        
        // Save to data store
        dataStore.bondData.totalBondAmount = amount
        dataStore.bondData.totalServiceDays = days
        dataStore.bondData.startDate = startDate
        dataStore.saveBondData()
        
        dismiss()
    }
}

#Preview {
    SetupView()
        .environmentObject(BondDataStore())
}

