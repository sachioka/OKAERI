//
//  SelectTask.swift
//  OKAERI
//
//  Created by sachi okada on 2020/10/27.
//

import Foundation
import SwiftUI
import CoreData

struct SelectTask: View {
    @Environment(\.managedObjectContext) var managedObjectContext:NSManagedObjectContext
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.taskname, ascending: true)
        ]
        
    ) var tasks: FetchedResults<Task>
    
    @State var isPresented = false
    var body: some View {
        Text("test")
    }
}

struct SelectTask_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
