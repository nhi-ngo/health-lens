//
//  HealthLensApp.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/16/24.
//

import SwiftUI

@main
struct HealthLensApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
