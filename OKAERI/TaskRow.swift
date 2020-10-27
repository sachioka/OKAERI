//
//  TaskRow.swift
//  OKAERI
//
//  Created by sachi okada on 2020/10/26.
//

import SwiftUI
import CoreData



struct TaskRow: View {
    let task: Task

//    日付をlong1値に直す
  static let deadLineFormatter: DateFormatter = {
    let formatter = DateFormatter()
//    formatter.dateStyle = .long
    formatter.dateFormat = "yyyy年MM月dd日"

    return formatter
  }()

  var body: some View {
    HStack(alignment: .center) {
        task.taskname.map(Text.init)
        .font(.title)
        Spacer()
//      HStack {
        Text("期限")
        task.deadline.map { Text(Self.deadLineFormatter.string(from: $0)) }
          .font(.headline)
//        Spacer()
//        movie.deadLine.map { Text(Self.releaseFormatter.string(from: $0)) }
//          .font(.caption)
//      }
    }
  }
}

//struct TaskRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskRow()
//    }
//}
