//
//  ContentView.swift
//  HealthKitSample
//
//  Created by oshima-katsutoshi on 2024/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var healthKitManager = HealthKitManager()

    var body: some View {
        VStack {
            Text("HealthKit Data")
                .font(.largeTitle)
                .padding()

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("歩数: ")
                    Spacer()
                    Text("\(Int(healthKitManager.stepCount)) 歩")
                }
                HStack {
                    Text("平均心拍数: ")
                    Spacer()
                    Text(String(format: "%.1f BPM", healthKitManager.heartRate))
                }
                HStack {
                    Text("睡眠時間: ")
                    Spacer()
                    Text(String(format: "%.2f 時間", healthKitManager.sleepHours))
                }
            }
            .padding()

            Button("データを更新") {
                healthKitManager.fetchStepCount()
                healthKitManager.fetchHeartRate()
                healthKitManager.fetchSleepAnalysis()
            }
            .padding()
        }
        .onAppear {
            healthKitManager.requestAuthorization { success, error in
                if success {
                    healthKitManager.fetchStepCount()
                    healthKitManager.fetchHeartRate()
                    healthKitManager.fetchSleepAnalysis()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
