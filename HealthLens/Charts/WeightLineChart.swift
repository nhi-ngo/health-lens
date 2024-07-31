//
//  WightLineChart.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/31/24.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    var minValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Weight", systemImage: "figure")
                            .font(.title3.bold())
                            .foregroundStyle(selectedStat.tint)
                        
                        Text("Avg: 110 lbs")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weight in
                    AreaMark(x: .value("Day", weight.date, unit: .day),
                             yStart: .value("Value", weight.value),
                             yEnd: .value("Min value", minValue)
                    )
                    .foregroundStyle(Gradient(colors: [.indigo.opacity(0.5), .clear]))
                    
                    LineMark(x: .value("Date", weight.date, unit: .day),
                             y: .value("Weight", weight.value)
                    )
                    .foregroundStyle(Color.indigo.gradient)
                }
            }
            .frame(height: 150)
            .chartYScale(domain: .automatic(includesZero: false))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}


#Preview {
    WeightLineChart(selectedStat: .weight,
                    chartData: MockData.weights)
}
