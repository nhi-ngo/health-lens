//
//  StepBarChart.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/27/24.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    // for the last 28 days. Timeframe comes from addSimulatorData()
    var avgStepCount: Double {
        guard !chartData.isEmpty else { return 0 }
        let totalSteps = chartData.reduce(0) {$0 + $1.value}
        return totalSteps / Double(chartData.count)
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Steps", systemImage: "figure.walk")
                            .font(.title3.bold())
                            .foregroundStyle(selectedStat.tint)
                        
                        Text("Avg: \(Int(avgStepCount)) steps")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            if chartData.isEmpty {
                ChartEmptyView(systemImageName: "chart.bar",
                               title: "No Data",
                               description: "There is no step count data from the Health App.")
            } else {
                Chart {
                    if let selectedHealthMetric {
                        RuleMark(x: .value("Selected metric", selectedHealthMetric.date, unit: .day))
                            .foregroundStyle(Color.secondary.opacity(0.3))
                            .offset(y: -10)
                            .annotation(position: .top,
                                        spacing: 0,
                                        overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) { annotationView }
                    }
                    
                    RuleMark(y: .value("Average", avgStepCount))
                        .foregroundStyle(Color.secondary)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                    
                    ForEach(chartData) { step in
                        BarMark(x: .value("Date", step.date, unit: .day),
                                y: .value("Steps", step.value)
                        )
                        .foregroundStyle(Color.pink.gradient)
                        .opacity(rawSelectedDate == nil || step.date == selectedHealthMetric?.date ? 1.0 : 0.3)
                    }
                }
                .frame(height: 150)
                
                // bar chart customizations
                // https://goshdarnformatstyle.com/numeric-styles/
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut)) // track where user is dragging along the chart
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                            .foregroundStyle(Color.secondary.opacity(0.3))
                        
                        AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if oldValue?.weekdayInt != newValue?.weekdayInt {
                selectedDay = newValue
            }
        }
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthMetric?.date ?? .now, format:.dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedHealthMetric?.value ?? 0, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(selectedStat.tint)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3),radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    StepBarChart(selectedStat: .steps,
                 chartData: [])
}
