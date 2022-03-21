//
//  BadHabitCounterData.swift
//  Bad Habit Counter
//
//  Created by Ryan Elliott on 3/6/22.
//

import Foundation

class BadHabitCounterData: Codable {
    var startDate: Date
    var habits: [Habit]
    
    init() {
        startDate = today()
        habits = []
    }
    
    func count(for date: Date) -> Int{
        var count: Int = 0
        for habit in habits {
            count += habit.show ? habit.get(date) : 0
        }
        return count
    }
}
