//
//  ContentView.swift
//  OKAERI
//
//  Created by sachi okada on 2020/10/15.
//

import SwiftUI
import HealthKit
import UIKit

struct ContentView: View {
    private var healthStore:HealthStore?
    @State private var steps: [Step] = [Step]()
    @State private var stepAve: [StepAve] = [StepAve]()
    @State var aveWeekSteps:Int = 0
    @State var aveMonthSteps:Int = 0
    @State var thanMonth :Bool = true
    @State var thanWeek :Bool = true
    @State private var Butonclick = false
    
    //@stateは変数の変更を行うために必要
    
//    private var colors: [UIColor] = [.red, .green, .orange]

    init(){
        healthStore = HealthStore()
    }
    //initでHealthStore.swiftのHealthStoreをhealthStoreに渡す
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {

        let startDate = Calendar.current.date(byAdding: .day, value: -30 , to: Date())!
//        let startDate = Date()
        
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            //期間内の統計やっちゃうよ
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
 
            let step = Step(count: Int(count ?? 0),date: statistics.startDate)
            steps.append(step)
            
            print(steps.count)
            //startDateからendDateまでの日々の歩数をsteps配列に追加する
            
        }
     }
    
    
    private func checkFatigue() {

        var sumWeekSteps:Int = 0
        var sumMonthSteps:Int = 0

        steps.sort{ $0.date > $1.date}

        for i  in 0..<7{
            sumWeekSteps += steps[i].count
        }
        for i  in 0..<30{
            sumMonthSteps += steps[i].count
        }
        aveMonthSteps = sumMonthSteps / 30
        aveWeekSteps = sumWeekSteps / 7
        
        
        thanMonth = (steps[0].count > aveMonthSteps)
        thanWeek = (steps[0].count > aveWeekSteps)
       
//        switch (thanWeek,thanMonth)   {
//                case (true,true):
//                 return
//                case (true,false):
//                 return Color.green
//                case (false,true)
//
//                default :
//                  return  Color.blue
//        }
        
//        print(steps)
//        print(aveWeekSteps)
    
    }
    private func backgoudColor (){
        
    }
    
    
//MARK:-body
    
    

    var body: some View {
        let yellow = Color(red: 248/255, green: 187/255, blue: 119/255)
        let pink = Color(red: 240/255, green: 154/255, blue: 127/255)
        let blue = Color(red: 184/255, green: 208/255, blue: 127/255)
//        let pink = Color(red: 240/255, green: 154/255, blue: 127/255)

        VStack{
            ZStack {
                Text("test")
            if (thanWeek && thanMonth){
                Text("test")
                LinearGradient(gradient: Gradient(colors: [blue,.white]), startPoint: .leading, endPoint: .trailing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)    // フレームサイズを最大に設定
                    .edgesIgnoringSafeArea(.all)
                
            }else if thanWeek && !thanMonth {
                LinearGradient(gradient: Gradient(colors: [blue, yellow]), startPoint: .top, endPoint: .trailing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                
                
            }else if !thanWeek && thanMonth {
                LinearGradient(gradient: Gradient(colors: [yellow, pink]), startPoint: .top, endPoint: .trailing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
            }else {

                LinearGradient(gradient: Gradient(colors: [pink, .white]), startPoint: .top, endPoint: .trailing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                Text("test")
                    if (Butonclick==true) {
                        Text("\(steps.count)")
                                        } else {
                                            
                                       }

                                    List {
                                    Button(action: {
                                            self.Butonclick = true}) {
                    //                             ここにタスク全て表示
                                        Text("タスク")
                                                .foregroundColor(Color.white)
                                                .padding()
                                                .background(Color.red)
                                                .cornerRadius(100)}
                                        .frame(alignment: .center);
                                    Spacer()
                                    }.frame(height:300)
                                    .opacity(0.5)
 
                }

            }
            }
//            Text("test")

        }
    
        
            


        
        //このviewが表示されたらおこわなれることが以下（.onappear）
            .onAppear{
                if let healthStore = healthStore  {
                    healthStore.requestAuthorization { success in
                     //heathcareに対する許可（今回は読み込み）されていればHealthStore.swift のcalculateStpsファンクションを実行
                        if success {
                            healthStore.calculateStps{ statisticsCollection in
                                if let statisticsCollection = statisticsCollection {
                                    DispatchQueue.main.async {
                                      updateUIFromStatistics(statisticsCollection)
                                        checkFatigue()
                                    }
//                                    updateUIFromStatistics(statisticsCollection)
                                }
                            }
                            
                            
                        }
                    }
                }
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
