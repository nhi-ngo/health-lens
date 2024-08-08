//
//  StepPieChart.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/30/24.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    
    @State private var rawSelectedValue: Double? = 0 // default selection to Sunday
    @State private var selectedDay: Date?
    
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
            
            if chartData.isEmpty {
                ChartEmptyView(systemImageName: "chart.pie",
                               title: "No Data",
                               description: "There is no step count data from the Health App.")
            } else {
                Chart {
                    ForEach(chartData) { weekday in
                        let isSelectedWeekday = selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt
                        
                        SectorMark(
                            angle: .value("Average Steps", weekday.value),
                            innerRadius: .ratio(0.618),
                            outerRadius: isSelectedWeekday ? 140: 110,
                            angularInset: 1
                        )
                        .foregroundStyle(.pink.gradient)
                        .cornerRadius(6)
                        .opacity(isSelectedWeekday ? 1.0 : 0.3)
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
                                        .animation(.interactiveSpring)
                                    
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
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        .onChange(of: rawSelectedValue) { oldValue, newValue in
            if newValue == nil {
                rawSelectedValue = oldValue
            }
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: selectedWeekday) { oldValue, newValue in
            guard let oldValue, let newValue else { return }
            if oldValue.date.weekdayInt != newValue.date.weekdayInt {
                selectedDay = newValue.date
            }
        }
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekdayCount(for: MockData.steps))
}
