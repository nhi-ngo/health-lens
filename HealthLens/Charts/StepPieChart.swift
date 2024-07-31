//
//  StepPieChart.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/30/24.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    
    @State private var rawSelectedValue: Double? = 0
    
    var chartData: [WeekdayChartData] = []
    
    var selectedWeekday: WeekdayChartData? {
        guard let rawSelectedValue else { return nil }
        var total = 0.0
        
        return chartData.first {
            total += $0.value
            return rawSelectedValue <= total
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Label("Averages", systemImage: "calendar")
                    .font(.title3.bold())
                    .foregroundStyle(.pink)
                
                Text("Last 28 days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weekday in
                    SectorMark(
                        angle: .value("Average Steps", weekday.value),
                        innerRadius: .ratio(0.618),
                        outerRadius: selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 140: 110,
                        angularInset: 1
                    )
                    .foregroundStyle(.pink.gradient)
                    .cornerRadius(6)
                    .opacity(selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 1.0 : 0.3)
                }
            }
            .chartAngleSelection(value: $rawSelectedValue.animation(.easeInOut)) // track user's selection along the chart
            .frame(height: 240)
            .chartBackground { proxy in
                GeometryReader { geometry in
                    if let plotFrame = proxy.plotFrame {
                       let frame = geometry[plotFrame]
                        if let selectedWeekday {
                            VStack {
                                Text(selectedWeekday.date.weekdayTitle)
                                    .font(.title3.bold())
                                    .contentTransition(.identity)
                                
                                Text(selectedWeekday.value, format: .number.precision(.fractionLength(0)))
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                    .contentTransition(.numericText())
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        //        .onChange(of: rawSelectedValue) { oldValue, newValue in
        //            print(newValue)
        //            print(selectedWeekday?.date.weekdayTitle)
        //        }
        
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekdayCount(for: HealthMetric.mockData))
}
