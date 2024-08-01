//
//  DashboardView.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/16/24.
//

import SwiftUI
import Charts

enum HealthMetricContext: String, CaseIterable, Identifiable {
    case steps, weight
    var id: Self { self }
    
    var tint: Color {
        switch self {
        case .steps:
            Color.pink
        case .weight:
            Color.indigo
        }
    }
}


struct DashboardView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    @State private var rawSelectedDate: Date?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Selected Stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedStat {
                    case .steps:
                        StepBarChart(selectedStat: selectedStat, chartData: hkManager.stepData)
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(selectedStat: selectedStat, chartData: hkManager.weightData)
                        WeightBarChart(chartData: ChartMath.averageDailyWeightDiff(for: hkManager.weightDiffData))
                    }
                    
                    
                }
            }
            .padding()
            .task {
                await hkManager.fetchStepCount()
                await hkManager.fetchWeights()
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .fullScreenCover(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                // fetch health data
            }, content: {
                HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
            })
        }
        .tint(selectedStat.tint)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
