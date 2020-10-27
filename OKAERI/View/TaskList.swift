//
//  TaskList.swift
//  OKAERI
//
//  Created by sachi okada on 2020/10/26.
//

import SwiftUI
import CoreData

struct TaskList: View {
    @Environment(\.managedObjectContext) var managedObjectContext:NSManagedObjectContext
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.taskname, ascending: true)
        ]

    ) var tasks: FetchedResults<Task>

    @State var isPresented = false
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(tasks, id: \.taskname) {
                        TaskRow(task: $0)
                    }
                    .onDelete(perform: deleteTask)
                }
                .sheet(isPresented: $isPresented) {
                    AddTask { taskname, deadline ,isComplete in
                        self.addTask(taskname: taskname,  deadline: deadline, isComplete: isComplete)
                        self.isPresented = false
                        
                    }
                }
                
                .navigationBarTitle(Text("OKAERI"))
                //      .navigationBarItems(trailing:
                
                //                赤ボタン
                Button(action: { self.isPresented.toggle() }) {
                    Image(systemName: "plus").resizable().frame(width: 25, height: 25).padding()
                }.foregroundColor(.white)
                .background(Color.red)
                .clipShape(Circle())
                .padding(.bottom)
                
                
            }
            
            
            //      )
        }
    }
//    削除関数
    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = self.tasks[index]
            self.managedObjectContext.delete(task)
        }
        saveContext()
    }
    
//    追加
    func addTask(taskname: String, deadline: Date, isComplete: Bool) {
        
        let newTask = Task(context: managedObjectContext)
        
        newTask.taskname = taskname
        newTask.deadline = deadline
        newTask.isComplete = false
        saveContext()
    }
    
//    セーブ関数
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}


struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
