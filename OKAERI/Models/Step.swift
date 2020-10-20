//
//  Step.swift
//  OKAERI
//
//  Created by sachi okada on 2020/10/15.
//

import Foundation
import SwiftUI
import CoreLocation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

struct StepAve: Identifiable {
    let id = UUID()
    let ave: Int
    let date: Date
}

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    


}
