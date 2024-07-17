//
//  HealthDataListView.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/17/24.
//

import SwiftUI

struct HealthDataListView: View {
    
    @State private var isShowingAddData = false
    
    var metric: HealthMetricContext
    
    var body: some View {
        List(0..<28) { i in
            HStack {
                Text(Date(), format: .dateTime.month().day().year())
                Spacer()
                Text(10000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            }
        }
        .navigationTitle(metric.rawValue.capitalized)
        .sheet(isPresented: $isShowingAddData) {
            Text("Add data sheet")
        }
        .toolbar {
            Button("Add data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .steps)
    }
}
