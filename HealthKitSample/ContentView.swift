import SwiftUI

struct ContentView: View {
    @StateObject var healthKitManager = HealthKitManager()

    var body: some View {
        VStack {
            // タイトル
            Text("HealthKit Data")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.blue)

            // データ表示部分
            VStack(alignment: .leading, spacing: 20) {
                // 歩数
                DataRowView(label: "歩数", value: "\(Int(healthKitManager.stepCount)) 歩")
                
                // 平均心拍数
                DataRowView(label: "平均心拍数", value: String(format: "%.1f BPM", healthKitManager.heartRate))
                
                // 睡眠時間
                DataRowView(label: "睡眠時間", value: String(format: "%.2f 時間", healthKitManager.sleepHours))
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()

            // データ更新ボタン
            Button(action: {
                healthKitManager.fetchStepCount()
                healthKitManager.fetchHeartRate()
                healthKitManager.fetchSleepAnalysis()
            }) {
                Text("データを更新")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            Spacer()
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

// 共通のデータ行ビュー
struct DataRowView: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
