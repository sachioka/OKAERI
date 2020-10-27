//
//  SomeView.swift
//  OKAERI
//
//  Created by sachi okada on 2020/10/25.
//

import SwiftUI

struct AddTask: View {
  static let DefaultTaskName = "タスク名を入力してください　　　　　"

  @State var taskname = ""
  @State var deadline = Date()
  @State var isComplete = false
  let onComplete: (String, Date, Bool) -> Void

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Task")) {
          TextField("Task", text: $taskname)
        }

        Section {
          DatePicker(
            selection: $deadline,
            displayedComponents: .date) {
              Text("いつまで").foregroundColor(Color(.gray))
          }
        }
        Section {
          Button(action: addTaskAction) {
            Text("Add Task")
          }
        }
      }
      .navigationBarTitle(Text("Task List"), displayMode: .inline)
    }
  }

  private func addTaskAction() {
    onComplete(
      taskname.isEmpty ? AddTask.DefaultTaskName : taskname,
        deadline,
        isComplete
        )
  }
}

//struct AddTask_Previews: PreviewProvider {
//    static var previews: some View {
////        AddTask()
//    }
//}
