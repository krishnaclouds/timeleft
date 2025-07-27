//
//  SharedModels.swift
//  timeleft
//
//  Created by Bala Krishna on 26/07/25.
//

import Foundation
import SwiftUI

// Shared Event model for both app and widget
struct SharedEvent: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var date: Date
    var createdAt: Date
    
    init(name: String, date: Date) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.createdAt = Date()
    }
    
    // Initialize with parameters (used by main app)
    init(id: UUID, name: String, date: Date, createdAt: Date) {
        self.id = id
        self.name = name
        self.date = date
        self.createdAt = createdAt
    }
}

// Shared constants
struct SharedConstants {
    static let appGroupIdentifier = "group.com.koffeecuptales.timeleft"
    static let eventsKey = "shared_events"
    static let selectedEventKey = "selected_widget_event"
}

// Shared utility functions
struct TimeCalculator {
    static func daysUntil(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: date))
        return components.day ?? 0
    }
    
    static func formattedTimeRemaining(for date: Date) -> (months: String, weeks: String, days: String, totalDays: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: date))
        let totalDays = max(0, components.day ?? 0)
        
        if totalDays > 90 {
            let months = totalDays / 30
            let remainingDaysAfterMonths = totalDays % 30
            let weeks = remainingDaysAfterMonths / 7
            let days = remainingDaysAfterMonths % 7
            
            let monthsText = months > 0 ? "\(months)m" : ""
            let weeksText = weeks > 0 ? "\(weeks)w" : ""
            let daysText = days > 0 ? "\(days)d" : ""
            
            return (monthsText, weeksText, daysText, totalDays)
        } else if totalDays > 30 {
            let weeks = totalDays / 7
            let remainingDays = totalDays % 7
            
            let weeksText = weeks > 0 ? "\(weeks)w" : ""
            let daysText = remainingDays > 0 ? "\(remainingDays)d" : ""
            
            return ("", weeksText, daysText, totalDays)
        } else {
            return ("", "", "\(totalDays)d", totalDays)
        }
    }
    
    static func timeUnitBreakdown(for date: Date) -> (months: Int, weeks: Int, days: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: date))
        let totalDays = max(0, components.day ?? 0)
        
        if totalDays > 90 {
            let months = totalDays / 30
            let remainingDaysAfterMonths = totalDays % 30
            let weeks = remainingDaysAfterMonths / 7
            let days = remainingDaysAfterMonths % 7
            return (months, weeks, days)
        } else if totalDays > 30 {
            let weeks = totalDays / 7
            let days = totalDays % 7
            return (0, weeks, days)
        } else {
            return (0, 0, totalDays)
        }
    }
}

// Shared data manager with fallback
class SharedDataManager {
    static let shared = SharedDataManager()
    private let userDefaults: UserDefaults
    
    private init() {
        // Try to use App Group UserDefaults first, fallback to standard UserDefaults
        if let appGroupDefaults = UserDefaults(suiteName: SharedConstants.appGroupIdentifier) {
            self.userDefaults = appGroupDefaults
        } else {
            // Fallback to standard UserDefaults if App Group is not available
            print("⚠️ App Group not available, using standard UserDefaults")
            self.userDefaults = UserDefaults.standard
        }
    }
    
    func saveEvents(_ events: [SharedEvent]) {
        if let encoded = try? JSONEncoder().encode(events) {
            userDefaults.set(encoded, forKey: SharedConstants.eventsKey)
            print("📱 Saved \(events.count) events to shared storage")
        }
    }
    
    func loadEvents() -> [SharedEvent] {
        if let data = userDefaults.data(forKey: SharedConstants.eventsKey),
           let decodedEvents = try? JSONDecoder().decode([SharedEvent].self, from: data) {
            print("📱 Loaded \(decodedEvents.count) events from shared storage")
            return decodedEvents
        }
        print("📱 No events found in shared storage")
        return []
    }
    
    func saveSelectedEventId(_ eventId: UUID?) {
        if let eventId = eventId {
            userDefaults.set(eventId.uuidString, forKey: SharedConstants.selectedEventKey)
            print("🎯 Selected event: \(eventId)")
        } else {
            userDefaults.removeObject(forKey: SharedConstants.selectedEventKey)
            print("🎯 Cleared selected event")
        }
    }
    
    func loadSelectedEventId() -> UUID? {
        if let idString = userDefaults.string(forKey: SharedConstants.selectedEventKey) {
            return UUID(uuidString: idString)
        }
        return nil
    }
    
    func getSelectedEvent() -> SharedEvent? {
        guard let selectedId = loadSelectedEventId() else { return nil }
        let events = loadEvents()
        return events.first { $0.id == selectedId }
    }
}