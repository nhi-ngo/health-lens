//
//  ChartEmptyView.swift
//  HealthLens
//
//  Created by Nhi Ngo on 8/8/24.
//

import SwiftUI

struct ChartEmptyView: View {
    
    let systemImageName: String
    let title: String
    let description: String
    
    var body: some View {
        ContentUnavailableView {
            Image(systemName: systemImageName)
                .font(.largeTitle)
                .fontWeight(.light)
                .padding(.bottom, 8)
            
            Text(title)
                .font(.callout.bold())
            
            Text(description)
                .font(.footnote)
        }
        .foregroundStyle(.secondary)
    }
}

#Preview {
    ChartEmptyView(systemImageName: "chart.bar", 
                   title: "No Data",
                   description: "There is no data")
}
