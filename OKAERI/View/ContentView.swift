//
//  ContentView.swift
//  OKAERI
//
//  Created by sachi okada on 2020/10/15.
//

import SwiftUI
import HealthKit
import CoreData


struct ContentView: View {
    private var healthStore:HealthStore?
    @State private var steps: [Step] = [Step]()
    @State var aveWeekSteps:Int = 0
    @State var aveMonthSteps:Int = 0
    @State var thanMonth :Bool = true
    @State var thanWeek :Bool = true
    @State private var selection = 0
    
    //    @State var isModal :Bool = false
    
    
    @Environment(\.managedObjectContext) var context:NSManagedObjectContext
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: false))
    ) var tasks: FetchedResults<Task>
    
    
    
    
    //@stateは変数の変更を行うために必要
    
    //    private var colors: [UIColor] = [.red, .green, .orange]
    
    init(){
        healthStore = HealthStore()
    }
    //initでHealthStore.swiftのHealthStoreをhealthStoreに渡す
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        
        let startDate = Calendar.current.date(byAdding: .day, value: -30 , to: Date())!
        
        
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            //期間内の統計やっちゃうよ
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0),date: statistics.startDate)
            steps.append(step)
            
                        print(steps)
            
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
        
        print(context)
        print(tasks)

    }
    
    
    //MARK:-parts1

    func changeBackgroudColor(n:Bool,_n:Bool) ->LinearGradient{
        var max = Color(red: 105/255, green: 170/255, blue: 0/255)
        var mid1 = Color(red: 148/255, green: 208/255, blue: 173/255)
        var mid2 = Color(red: 182/255, green: 247/255, blue: 72/255)
        var min = Color(red: 166/255, green: 181/255, blue: 186/255)
        var white = Color(red: 250/255, green: 250/255, blue: 250/255)
        
        if (n && _n){
            print("1")
            return LinearGradient(gradient: Gradient(colors:[min, white]), startPoint: .top, endPoint: .trailing)
            
        }else if (n && !_n){
            print("2")
            return LinearGradient(gradient: Gradient(colors:[mid1,white]), startPoint: .top, endPoint: .trailing)
            
        }else if (!n && _n){
            print("3")
            return LinearGradient(gradient: Gradient(colors:[mid2, white]), startPoint: .top, endPoint: .trailing)
            
        }else if (!n && !_n){
            print("4")
            return LinearGradient(gradient: Gradient(colors:[min, white]), startPoint: .top, endPoint: .trailing)
            
        }
        //
        print("5")
        return LinearGradient(gradient: Gradient(colors:[min, .white]), startPoint: .top, endPoint: .trailing)
        
    }
    //MARK:-parts1-end
//    changeBackgroudColor(n:thanWeek,_n:thanMonth)
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//    .edgesIgnoringSafeArea(.all)
    
    var body: some View {
        var selectedColor = changeBackgroudColor(n:thanWeek,_n:thanMonth)

        
        VStack{
            
            TabView(selection:$selection){
                
                ZStack{
                    
                    Text("おかえりなさい")
                        Text()
                        
                        .listRowBackground(changeBackgroudColor(n:thanWeek,_n:thanMonth))
                    List{
                        
                        ForEach(tasks){ task in
                            Button(action: {
                                self.updateTask(task)
                                
                            }){
                                TaskRow(task: task)
                                
                            }
                            
                        }
                        .padding(20)
                    }
                    
                    .tabItem{
                        Text("addTask")
                    }
                    
                }
                
                .tag(0)
                VStack{
                    TaskList()
                }
                .tabItem{
                    Text("selectTask")
                }
                
                .tag(2)
                
            }
            
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
                                    changeBackgroudColor(n:thanWeek,_n:thanMonth)
                                }
                                //                                    updateUIFromStatistics(statisticsCollection)
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    
    
    
    func updateTask(_ task: Task){
        let isComplete = true
        let taskID = task.id! as NSUUID
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskID as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            let test = try context.fetch(fetchRequest)
            let taskUpdate = test[0] as! NSManagedObject
            taskUpdate.setValue(isComplete, forKey: "isComplete")
        } catch {
            print(error)
        }
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
