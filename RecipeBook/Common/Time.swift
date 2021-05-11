//
//  Time.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/12/02.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import Foundation

struct Time {
    var hour, minutes, second : Int
    
    var displayTime: String {
        String(format: "%02d:%02d:%02d", hour, minutes, second)
    }
    
    var intervalTime: TimeInterval {
        TimeInterval(hour * 3600 + minutes * 60 + second)
    }
    
    var timeUp: Bool {
        return intervalTime <= 0
    }
    
    var isZero: Bool {
        hour <= 0 && minutes <= 0 && second <= 0
    }
    
    mutating func set(hour: String?) {
        guard let hour = hour else { return }
        self.hour = Int(hour) ?? 0
    }
    
    mutating func set(minutes: String?) {
        guard let minutes = minutes else { return }
        self.minutes = Int(minutes) ?? 0
    }
    
    mutating func set(second: String?) {
        guard let second = second else { return }
        self.second = Int(second) ?? 0
    }
    
    mutating func countDown() {
        if second > 0 {
            second -= 1
        } else if minutes > 0 {
            minutes -= 1
            second = 59
        } else if hour > 0 {
            hour -= 1
            minutes = 59
        }
    }
}
