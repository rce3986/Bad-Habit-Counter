//
//  Helpers.swift
//  Bad Habit Counter
//
//  Created by Ryan Elliott on 3/10/22.
//

import Foundation
import UIKit

/// Data stuff

// Returns nil if url couldn't be retrieved (prompt to try again)
func load() -> BadHabitCounterData? {
    guard let url = getURL() else {
        print("data loading failed")
        return nil
    }
    
    return load(url: url)
}

func load(url: URL) -> BadHabitCounterData? {
    guard let data = retrieve(url: url) else {
        print("data doesn't exist yet")
        return BadHabitCounterData()
    }
    
    return decode(data: data)
}

func retrieve(url: URL) -> Data? {
    do {
        let data = try Data(contentsOf: url, options: .alwaysMapped)
        return data
    } catch {
        print("data retrieval failed")
        return nil
    }
}

func decode(data: Data) -> BadHabitCounterData? {
    do {
        let badHabitCounterData = try JSONDecoder().decode(BadHabitCounterData.self, from: data)
        return badHabitCounterData
    } catch {
        print("data decoding failed")
        return nil
    }
}

func write<T: Encodable>(data: T) -> Bool {
    guard let url = getURL() else {
        print("json write failed")
        return false
    }
    
    return write(url: url, data: data)
}

func write<T: Encodable>(url: URL, data: T) -> Bool {
    do {
        try JSONEncoder().encode(data).write(to: url)
        return true
    } catch {
        print("json write failed")
        return false
    }
}

func getURL() -> URL? {
    return getURL(filename: "bad-habit-counter-data")
}

// URL for data in Application Storage
func getURL(filename: String) -> URL? {
    do {
        let url = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(filename)
        return url
    } catch {
        print("url retrieval failed")
        return nil
    }
}


func toJson<T: Encodable>(_ data: T) -> String? {
    do {
        let data = try JSONEncoder().encode(data)
        return String(data: data, encoding: String.Encoding.utf8)!
    } catch {
        print("data encoding failed")
        return nil
    }
    
}

/// Date stuff

func startOfDay(of date: Date) -> Date {
    return Calendar(identifier: .gregorian).startOfDay(for: date)
}

func endOfDay(for date: Date) -> Date {
    var components = DateComponents()
    components.day = 1
    components.second = -1
    return Calendar(identifier: .gregorian).date(byAdding: components, to: date)!
}

func today() -> Date {
    return startOfDay(of: Date())
}

func iso(_ s: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withFullDate
    return formatter.date(from: s)
}

/// setUp

// order for spacing is [top bottom leading trailing]
func setUp(_ child: UIView, in parent: UIView, top topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>?, bottom bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>?, leading leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>?, trailing trailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>?, spacing: [CGFloat]) {
    
    parent.addSubview(child)
    
    child.translatesAutoresizingMaskIntoConstraints = false
    if let top = topAnchor {
        child.topAnchor.constraint(equalTo: top, constant: spacing[0]).isActive = true
    }
    if let bottom = bottomAnchor {
        child.bottomAnchor.constraint(equalTo: bottom, constant: -spacing[1]).isActive = true
    }
    if let leading = leadingAnchor {
        child.leadingAnchor.constraint(equalTo: leading, constant: spacing[2]).isActive = true
    }
    if let trailing = trailingAnchor {
        child.trailingAnchor.constraint(equalTo: trailing, constant: -spacing[3]).isActive = true
    }
}

func setUp(_ child: UIView, in parent: UIView, top topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>?, bottom bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>?, leading leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>?, trailing trailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>?) {
    setUp(child, in: parent, top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, spacing: [0, 0, 0, 0])
}

func setUp(_ child: UIView, in parent: UIView, padding s: CGFloat) {
    setUp(child, in: parent, top: parent.topAnchor, bottom: parent.bottomAnchor, leading: parent.leadingAnchor, trailing: parent.trailingAnchor, spacing: [s, s, s, s])
}

func setUp(_ child: UIView, in parent: UIView) {
    setUp(child, in: parent, padding: 0)
}
