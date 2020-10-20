//
//  HealthStore.swift
//  OKAERI
//
//  Created by sachi okada on 2020/10/15.
//

import Foundation
import HealthKit

extension Date{
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}


class HealthStore {
    
    var healthStore:HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
        }
    }
    //ヘルスケアの許可を求めるイニシャライザ
    
    func calculateStps(completion: @escaping (HKStatisticsCollection?) -> Void){
        //@escapingはスコープの外でも使うときに必要
        let stepType = HKQuantityType.quantityType(forIdentifier:HKQuantityTypeIdentifier.stepCount)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -30 , to: Date())
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day:1)
        //DateComponentsは時間の間隔を指定する（今回は１日ごとなのでday:1）
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        //述語（？）これを指定することでよりデータを取りやすくなるとWWDC2020お姉さんが言っていた
        //今回はHKQueryというヘルケアの大元のクラスから特定のものを抜くために「開始をstartDate,終わりをendDateでデータが欲しい！」という意味
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        //特定の期間内の特定の間隔でそれぞれのクエリを実行する
        //今回はstepTypeを開始日から終了日まで(predicate)の１日ごと( intervalComponents: daily)合計(.cumulativeSum)で繰り返す、基準は月曜１２時
        
        query!.initialResultsHandler = { query, statisticsCollection, error in completion(statisticsCollection)
        }
        //初期結果を返すハンドラ
        //今回はクエリの結果が返せたら完了
        
        if let healthStore = healthStore,let query = self.query{
            healthStore.execute(query)
        }
        //クエリが実行できたらhealthStoreにhealthStoreを返す
    }
    

    
    
    func storeTest(completion: @escaping (HKStatisticsCollection?) -> Void){
        //@escapingはスコープの外でも使うときに必要
        let flightsClimbedType = HKQuantityType.quantityType(forIdentifier:HKQuantityTypeIdentifier.flightsClimbed)!
        let startDate = Calendar.current.date(byAdding: .day, value: -30 , to: Date())
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day:1)
        //DateComponentsは時間の間隔を指定する（今回は１日ごとなのでday:1）
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType:flightsClimbedType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
     
        query!.initialResultsHandler = { query, statisticsCollection, error in completion(statisticsCollection)
        }
        //初期結果を返すハンドラ
        //今回はクエリの結果が返せたら完了
        
        if let healthStore = healthStore,let query = self.query{
            healthStore.execute(query)
        }
        
    }

    
    
    func requestAuthorization(completion: @escaping (Bool) ->Void){
        
        let stepType = HKQuantityType.quantityType(forIdentifier:HKQuantityTypeIdentifier.stepCount)!

        //healthStoreから参照したいデータを数量を格納するタイプであるHKquanriryTypeで変数に渡す
        
        
        guard  let healthStore = self.healthStore else {return completion(false)}
        //許可を求めるやつ
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in completion(success)}
        //to share = 書き込み, read = 読み込み,完了したらどうするか
    }
}
