# HealthKitデータ表示アプリ

このアプリは、iOSデバイスのHealthKitから歩数、平均心拍数、睡眠時間のデータを取得し、ユーザーインターフェイスに表示します。ユーザーは「データを更新」ボタンを押すことで、最新のデータを簡単に取得できます。

## 機能

- **歩数表示**: 当日の合計歩数を表示します。
- **平均心拍数表示**: 当日の平均心拍数をBPM（beats per minute）で表示します。
- **睡眠時間表示**: 当日の睡眠時間（in bedの時間）を時間単位で表示します。
- **データ更新**: ボタンを押すと、歩数、平均心拍数、睡眠時間を最新のデータに更新します。

## 使用技術

- **SwiftUI**: アプリのUI構築に使用しています。
- **HealthKit**: ユーザーの健康データにアクセスし、取得・表示するために使用しています。

## 必要条件

- iOS 13以降
- HealthKitをサポートするデバイス

## セットアップ手順

1. **HealthKitの有効化**: 
   - Xcodeプロジェクトのターゲット設定で、`Signing & Capabilities`タブを開き、「+Capability」ボタンをクリックしてHealthKitを追加してください。

2. **権限のリクエスト**: 
   - 初回起動時に、HealthKitから健康データ（歩数、心拍数、睡眠データ）にアクセスするための権限をリクエストします。ユーザーが許可した場合、データの取得が可能になります。

3. **ビルドと実行**:
   - アプリをビルドして実行します。起動時に権限リクエストが表示され、ユーザーの許可が必要です。

## 使用方法

1. アプリを起動すると、HealthKitからデータを読み込む許可を求められますので、許可を与えてください。
2. 許可後、自動的に現在の歩数、平均心拍数、睡眠時間が表示されます。
3. データを更新したい場合は、「データを更新」ボタンをタップしてください。

## ファイル構成

- **ContentView.swift**: アプリのUIと、HealthKitからのデータを表示するためのViewを定義しています。
- **HealthKitManager.swift**: HealthKitからデータを取得し、必要な権限をリクエストするマネージャークラスです。

## 免責事項

- このアプリは個人の健康データを使用するため、使用する際は適切な権限とプライバシーの取り扱いに注意してください。
- 本アプリは情報提供のみを目的としており、医療的なアドバイスを提供するものではありません。