import HealthKit

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()

    @Published var stepCount: Double = 0.0
    @Published var heartRate: Double = 0.0
    @Published var sleepHours: Double = 0.0

    // 権限のリクエスト
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!

        let readTypes: Set = [stepType, heartRateType, sleepType]
        
        // toShareは書き込み権限のため今回はnil
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            completion(success, error)
        }
    }

    // 歩数データの取得（0時から現在時刻までの合計）
    func fetchStepCount() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date()) // 今日の0時
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let sum = result?.sumQuantity() {
                DispatchQueue.main.async {
                    self.stepCount = sum.doubleValue(for: HKUnit.count())
                }
            }
        }
        healthStore.execute(query)
    }

    // 心拍数データの取得（0時から現在時刻までの平均）
    func fetchHeartRate() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, error in
            if let avg = result?.averageQuantity() {
                DispatchQueue.main.async {
                    self.heartRate = avg.doubleValue(for: HKUnit(from: "count/min"))
                }
            }
        }
        healthStore.execute(query)
    }

    // 睡眠データの取得（1日のinBedの時間）
    func fetchSleepAnalysis() {
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 0, sortDescriptors: nil) { _, results, error in
            var totalSleep: Double = 0

            if let results = results as? [HKCategorySample] {
                for sample in results {
                    if sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
                        let sleepDuration = sample.endDate.timeIntervalSince(sample.startDate)
                        totalSleep += sleepDuration
                    }
                }
            }
            DispatchQueue.main.async {
                self.sleepHours = totalSleep / 3600  // 秒から時間に変換
            }
        }
        healthStore.execute(query)
    }
}
