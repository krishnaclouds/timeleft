//
//  TimeleftWidget.swift
//  TimeleftWidget
//
//  Created by Bala Krishna on 26/07/25.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider
struct TimeleftProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimeleftEntry {
        TimeleftEntry(
            date: Date(),
            event: SharedEvent(name: "Sample Event", date: Date().addingTimeInterval(86400 * 30)),
            hasEvents: false
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (TimeleftEntry) -> ()) {
        let entry = createEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = createEntry()
        
        // Update every hour
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        
        completion(timeline)
    }
    
    private func createEntry() -> TimeleftEntry {
        let events = SharedDataManager.shared.loadEvents()
        
        if let firstEvent = events.sorted(by: { $0.date < $1.date }).first {
            return TimeleftEntry(date: Date(), event: firstEvent, hasEvents: true)
        } else {
            return TimeleftEntry(
                date: Date(),
                event: SharedEvent(name: "No Events Yet", date: Date()),
                hasEvents: false
            )
        }
    }
}

// MARK: - Timeline Entry
struct TimeleftEntry: TimelineEntry {
    let date: Date
    let event: SharedEvent
    let hasEvents: Bool
}

// MARK: - Widget Views
struct TimeleftWidgetEntryView: View {
    var entry: TimeleftProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
            case .systemMedium:
                MediumWidgetView(entry: entry)
            case .systemLarge:
                LargeWidgetView(entry: entry)
            default:
                SmallWidgetView(entry: entry)
            }
        }
    }
}

// MARK: - Small Widget
struct SmallWidgetView: View {
    let entry: TimeleftEntry
    
    var body: some View {
        ZStack {
            // Floral background
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.94, blue: 0.96), Color(red: 0.95, green: 0.87, blue: 0.93)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Subtle floral pattern
            VStack {
                HStack {
                    Spacer()
                    Text("🌸")
                        .font(.caption2)
                        .opacity(0.3)
                }
                Spacer()
                HStack {
                    Text("🌺")
                        .font(.caption2)
                        .opacity(0.2)
                    Spacer()
                }
            }
            .padding(8)
            
            // Content
            VStack(spacing: 4) {
                Text(entry.event.name)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.4))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                if entry.hasEvents {
                    let timeInfo = TimeCalculator.formattedTimeRemaining(for: entry.event.date)
                    let timeText = [timeInfo.months, timeInfo.weeks, timeInfo.days]
                        .filter { !$0.isEmpty }
                        .joined(separator: " ")
                    
                    if timeInfo.totalDays <= 0 {
                        Text("OVERDUE")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.red)
                    } else if timeInfo.totalDays <= 30 {
                        Text("\(timeInfo.totalDays) days left")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.7))
                    } else {
                        Text(timeText)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.7))
                    }
                } else {
                    Text("Add events in app")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
        }
    }
}

// MARK: - Medium Widget
struct MediumWidgetView: View {
    let entry: TimeleftEntry
    
    var body: some View {
        ZStack {
            // Floral background
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.94, blue: 0.96), Color(red: 0.95, green: 0.87, blue: 0.93)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            if entry.hasEvents {
                HStack(spacing: 12) {
                    // Event info
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.event.name)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.4))
                            .lineLimit(2)
                        
                        Text(entry.event.date, style: .date)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("remaining")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    // Time units
                    let breakdown = TimeCalculator.timeUnitBreakdown(for: entry.event.date)
                    HStack(spacing: 6) {
                        if breakdown.months > 0 {
                            TimeUnitCard(value: breakdown.months, unit: "months", color: .purple)
                        }
                        if breakdown.weeks > 0 {
                            TimeUnitCard(value: breakdown.weeks, unit: "weeks", color: .blue)
                        }
                        if breakdown.days > 0 || (breakdown.months == 0 && breakdown.weeks == 0) {
                            TimeUnitCard(value: breakdown.days, unit: "days", color: .green)
                        }
                    }
                }
                .padding(16)
            } else {
                VStack(spacing: 8) {
                    Text("🌸")
                        .font(.title)
                        .opacity(0.6)
                    
                    Text("No Events Yet")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.4))
                    
                    Text("Add events in the app to see them here")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(16)
            }
        }
    }
}

// MARK: - Large Widget
struct LargeWidgetView: View {
    let entry: TimeleftEntry
    
    var body: some View {
        ZStack {
            // Floral background
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.94, blue: 0.96), Color(red: 0.95, green: 0.87, blue: 0.93)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            if entry.hasEvents {
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 4) {
                        Text(entry.event.name)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.4))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                        
                        Text(entry.event.date, style: .date)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    // Time units
                    let breakdown = TimeCalculator.timeUnitBreakdown(for: entry.event.date)
                    HStack(spacing: 8) {
                        if breakdown.months > 0 {
                            TimeUnitCard(value: breakdown.months, unit: "months", color: .purple)
                        }
                        if breakdown.weeks > 0 {
                            TimeUnitCard(value: breakdown.weeks, unit: "weeks", color: .blue)
                        }
                        if breakdown.days > 0 || (breakdown.months == 0 && breakdown.weeks == 0) {
                            TimeUnitCard(value: breakdown.days, unit: "days", color: .green)
                        }
                    }
                    
                    Text("remaining")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    // Mini dot visualization
                    let totalDays = TimeCalculator.daysUntil(entry.event.date)
                    if totalDays > 0 && totalDays <= 100 {
                        MiniDotVisualizationView(totalDays: totalDays)
                    }
                    
                    Spacer()
                }
                .padding(20)
            } else {
                VStack(spacing: 12) {
                    Text("🌸")
                        .font(.system(size: 48))
                        .opacity(0.6)
                    
                    Text("No Events Yet")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.4))
                    
                    Text("Add events in the app to see them here with beautiful visualizations")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(20)
            }
        }
    }
}

// MARK: - Helper Views
struct TimeUnitCard: View {
    let value: Int
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            Text(unit)
                .font(.system(size: 8, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
}

struct MiniDotVisualizationView: View {
    let totalDays: Int
    
    var body: some View {
        let dotsPerRow = 20
        let maxRows = 3
        let maxDots = dotsPerRow * maxRows
        let dotsToShow = min(totalDays, maxDots)
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: dotsPerRow), spacing: 1) {
            ForEach(0..<dotsToShow, id: \.self) { index in
                Circle()
                    .fill(Color(red: 0.3, green: 0.4, blue: 0.7))
                    .frame(width: 3, height: 3)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Widget Configuration
struct TimeleftWidget: Widget {
    let kind: String = "TimeleftWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: TimeleftProvider()
        ) { entry in
            if #available(iOS 17.0, *) {
                TimeleftWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TimeleftWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Timeleft")
        .description("Track time remaining until your important events.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Previews
#Preview(as: .systemSmall) {
    TimeleftWidget()
} timeline: {
    TimeleftEntry(
        date: .now,
        event: SharedEvent(name: "Wedding Day", date: Date().addingTimeInterval(86400 * 45)),
        hasEvents: true
    )
}

#Preview(as: .systemMedium) {
    TimeleftWidget()
} timeline: {
    TimeleftEntry(
        date: .now,
        event: SharedEvent(name: "Graduation", date: Date().addingTimeInterval(86400 * 120)),
        hasEvents: true
    )
}

#Preview(as: .systemLarge) {
    TimeleftWidget()
} timeline: {
    TimeleftEntry(
        date: .now,
        event: SharedEvent(name: "Summer Vacation", date: Date().addingTimeInterval(86400 * 30)),
        hasEvents: true
    )
}