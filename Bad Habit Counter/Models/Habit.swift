//
//  Habit.swift
//  Bad Habit Counter
//
//  Created by Ryan Elliott on 3/10/22.
//

import Foundation

class Habit: Codable {
    var name: String
    var counts: [Date: Int]
    var total: Int
    var show: Bool
    
    init(_ habit: String) {
        name = habit
        counts = [:]
        total = 0
        show = true
    }
    
    func get(_ date: Date) -> Int {
        return counts[startOfDay(of: date)] ?? 0
    }
    
    func put(date: Date, count: Int) {
        counts[startOfDay(of: date)] = count
    }
    
    func increment() {
        let date = Date()
        total += 1
        put(date: date, count: get(date)+1)
    }
    
    func toggle() {
        show = !show
    }
}
