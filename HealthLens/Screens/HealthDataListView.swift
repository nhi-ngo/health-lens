//
//  HealthDataListView.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/17/24.
//

import SwiftUI

struct HealthDataListView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingAddData = false
    @State private var addedDate: Date = .now
    @State private var addedValue: String = ""
    
    var metric: HealthMetricContext
    
    var listData: [HealthMetric] {
        metric == .steps ? hkManager.stepData : hkManager.weightData
    }
    
    var body: some View {
        List(listData.reversed()) { data in
//            HStack {
//                Text(Date(), format: .dateTime.month().day().year())
//                Spacer()
//                Text(10000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
//            }
            LabeledContent {
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
                    .foregroundStyle(.primary)
            } label: {
                Text(data.date, format: .dateTime.month().day().year())
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
                DatePicker("Date", selection: $addedDate, displayedComponents: .date)
                LabeledContent(metric.rawValue.capitalized) {
                    TextField("Value", text: $addedValue)
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
                        Task {
                            if metric == .steps {
                                await hkManager.addStepData(for: addedDate, value: Double(addedValue)!)
                                await hkManager.fetchStepCount()
                                isShowingAddData = false
                            } else {
                                await hkManager.addWeightData(for: addedDate, value: Double(addedValue)!)
                                await hkManager.fetchWeights()
                                await hkManager.fetchWeightsForDifferentials()
                                isShowingAddData = false
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .weight)
            .environment(HealthKitManager())
    }
}
