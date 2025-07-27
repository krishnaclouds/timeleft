//
//  SimpleTimeleftWidget.swift
//  Simple Timeleft Widget
//
//  Created by Bala Krishna on 26/07/25.
//

import WidgetKit
import SwiftUI

// Simple Timeline Provider
struct SimpleTimeleftProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleTimeleftEntry {
        SimpleTimeleftEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleTimeleftEntry) -> ()) {
        let entry = SimpleTimeleftEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = SimpleTimeleftEntry(date: currentDate)
        
        // Update every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
}

// Simple Timeline Entry
struct SimpleTimeleftEntry: TimelineEntry {
    let date: Date
}

// Widget Entry View
struct SimpleTimeleftWidgetEntryView: View {
    var entry: SimpleTimeleftProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallSimpleWidgetView(date: entry.date)
        case .systemMedium:
            MediumSimpleWidgetView(date: entry.date)
        default:
            SmallSimpleWidgetView(date: entry.date)
        }
    }
}

// Small Widget View
struct SmallSimpleWidgetView: View {
    let date: Date
    
    private var dayOfYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
    }
    
    private var daysInYear: Int {
        let year = Calendar.current.component(.year, from: date)
        return Calendar.current.range(of: .day, in: .year, for: date)?.count ?? 365
    }
    
    var body: some View {
        ZStack {
            // Floral background matching the main app
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.95, blue: 0.92),
                    Color(red: 0.95, green: 0.92, blue: 0.95),
                    Color(red: 0.92, green: 0.95, blue: 0.92)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                // App branding
                Text("⏰")
                    .font(.title2)
                
                Text("Timeleft")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
                
                // Motivational content
                VStack(spacing: 4) {
                    Text("Day \(dayOfYear)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("of \(daysInYear)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("Make it count")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .italic()
            }
            .padding(12)
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

// Medium Widget View
struct MediumSimpleWidgetView: View {
    let date: Date
    
    private var dayOfYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
    }
    
    private var daysInYear: Int {
        Calendar.current.range(of: .day, in: .year, for: date)?.count ?? 365
    }
    
    private var progressPercent: Double {
        Double(dayOfYear) / Double(daysInYear)
    }
    
    var body: some View {
        ZStack {
            // Floral background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.95, blue: 0.92),
                    Color(red: 0.95, green: 0.92, blue: 0.95),
                    Color(red: 0.92, green: 0.95, blue: 0.92)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Subtle floral elements
            GeometryReader { geometry in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.pink.opacity(0.03), Color.pink.opacity(0.01)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.3)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.purple.opacity(0.02), Color.purple.opacity(0.01)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.7)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("⏰")
                            .font(.title3)
                        Text("Timeleft")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    
                    Text("Every moment matters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    // Year progress
                    VStack(spacing: 4) {
                        Text("Day \(dayOfYear)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        Text("of \(daysInYear)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Progress bar
                    ProgressView(value: progressPercent)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(y: 1.5)
                        .frame(width: 60)
                    
                    Text("\(Int(progressPercent * 100))%")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

// Main Widget Configuration
struct SimpleTimeleftWidget: Widget {
    let kind: String = "SimpleTimeleftWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SimpleTimeleftProvider()) { entry in
            SimpleTimeleftWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Timeleft")
        .description("Stay motivated with time awareness. Every moment counts!")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// Widget Bundle
@main
struct SimpleTimeleftWidgetBundle: WidgetBundle {
    var body: some Widget {
        SimpleTimeleftWidget()
    }
}

// Preview
#Preview(as: .systemSmall) {
    SimpleTimeleftWidget()
} timeline: {
    SimpleTimeleftEntry(date: Date())
}

#Preview(as: .systemMedium) {
    SimpleTimeleftWidget()
} timeline: {
    SimpleTimeleftEntry(date: Date())
}