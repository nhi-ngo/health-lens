//
//  HealthDataListView.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/17/24.
//

import SwiftUI

struct HealthDataListView: View {
    
    @State private var isShowingAddData = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    var metric: HealthMetricContext
    
    var body: some View {
        List(0..<28) { i in
//            HStack {
//                Text(Date(), format: .dateTime.month().day().year())
//                Spacer()
//                Text(10000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
//            }
            LabeledContent {
                Text(10000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
                    .foregroundStyle(.primary)
            } label: {
                Text(Date(), format: .dateTime.month().day().year())
            }

        }
        .navigationTitle(metric.rawValue.capitalized)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                LabeledContent(metric.rawValue.capitalized) {
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 50)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.rawValue.capitalized)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .weight)
    }
}
