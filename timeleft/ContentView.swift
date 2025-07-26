//
//  ContentView.swift
//  timeleft
//
//  Created by Bala Krishna on 25/07/25.
//

import SwiftUI

struct Event: Identifiable, Codable {
    let id = UUID()
    var name: String
    var date: Date
    var createdAt: Date = Date()
}

struct ContentView: View {
    @State private var events: [Event] = []
    @State private var showingAddEvent = false
    
    var body: some View {
        NavigationView {
            EventListView(events: $events, showingAddEvent: $showingAddEvent)
        }
        .background(FloralBackground())
        .sheet(isPresented: $showingAddEvent) {
            AddEventView(events: $events)
        }
        .onAppear {
            loadEvents()
        }
    }
    
    private func loadEvents() {
        if let data = UserDefaults.standard.data(forKey: "events"),
           let decodedEvents = try? JSONDecoder().decode([Event].self, from: data) {
            events = decodedEvents
        }
    }
}

struct EventListView: View {
    @Binding var events: [Event]
    @Binding var showingAddEvent: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Events")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
                
                Button(action: {
                    showingAddEvent = true
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if events.isEmpty {
                Spacer()
                VStack(spacing: 20) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("No Events Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Tap the + button to add your first event")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            } else {
                List {
                    ForEach(events.sorted(by: { $0.date < $1.date })) { event in
                        NavigationLink(destination: EventDetailView(event: event, events: $events)) {
                            EventRowView(event: event)
                        }
                    }
                    .onDelete(perform: deleteEvents)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarHidden(true)
    }
    
    private func deleteEvents(offsets: IndexSet) {
        let sortedEvents = events.sorted(by: { $0.date < $1.date })
        for index in offsets {
            if let eventIndex = events.firstIndex(where: { $0.id == sortedEvents[index].id }) {
                events.remove(at: eventIndex)
            }
        }
        saveEvents()
    }
    
    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "events")
        }
    }
}

struct EventRowView: View {
    let event: Event
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(event.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if abs(daysUntil(event.date)) > 90 {
                    HStack(spacing: 2) {
                        Text(formattedTimeRemaining.months)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(daysUntil(event.date) >= 0 ? .orange : .red)
                        
                        Text(formattedTimeRemaining.weeks)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(daysUntil(event.date) >= 0 ? .purple : .red)
                        
                        Text(formattedTimeRemaining.days)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(daysUntil(event.date) >= 0 ? .blue : .red)
                    }
                } else if abs(daysUntil(event.date)) > 30 {
                    HStack(spacing: 2) {
                        Text(formattedTimeRemaining.weeks)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(daysUntil(event.date) >= 0 ? .purple : .red)
                        
                        Text(formattedTimeRemaining.days)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(daysUntil(event.date) >= 0 ? .blue : .red)
                    }
                } else {
                    Text("\(abs(daysUntil(event.date))) days")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(daysUntil(event.date) >= 0 ? .blue : .red)
                }
                
                Text(daysUntil(event.date) >= 0 ? "remaining" : "overdue")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func daysUntil(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: date))
        return components.day ?? 0
    }
    
    private var formattedTimeRemaining: (months: String, weeks: String, days: String) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: event.date))
        let totalDays = max(0, components.day ?? 0)
        
        if totalDays > 90 {
            let months = totalDays / 30
            let remainingDaysAfterMonths = totalDays % 30
            let weeks = remainingDaysAfterMonths / 7
            let days = remainingDaysAfterMonths % 7
            
            let monthsText = months > 0 ? "\(months)m" : ""
            let weeksText = weeks > 0 ? "\(weeks)w" : ""
            let daysText = days > 0 ? "\(days)d" : ""
            
            return (monthsText, weeksText, daysText)
        } else {
            let weeks = totalDays / 7
            let remainingDays = totalDays % 7
            
            let weeksText = weeks > 0 ? "\(weeks)w" : ""
            let daysText = remainingDays > 0 ? "\(remainingDays)d" : ""
            
            return ("", weeksText, daysText)
        }
    }
}

struct AddEventView: View {
    @Binding var events: [Event]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventName = ""
    @State private var eventDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                FloralBackground()
                
                VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Text("Add New Event")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Event Name")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter event name", text: $eventName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Target Date")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        DatePicker("Target Date", selection: $eventDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: addEvent) {
                    Text("Add Event")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(eventName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(eventName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func addEvent() {
        let newEvent = Event(name: eventName.trimmingCharacters(in: .whitespacesAndNewlines), date: eventDate)
        events.append(newEvent)
        saveEvents()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "events")
        }
    }
}

struct EventDetailView: View {
    let event: Event
    @Binding var events: [Event]
    @State private var currentDate = Date()
    @State private var showingEditEvent = false
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Text(event.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(event.date, style: .date)
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            
            if event.date > currentDate {
                VStack(spacing: 20) {
                    if totalDaysInPeriod > 90 {
                        VStack(spacing: 15) {
                            HStack(spacing: 15) {
                                if !formattedTimeRemaining.months.isEmpty {
                                    TimeUnitCard(
                                        value: String(daysRemaining / 30),
                                        unit: daysRemaining / 30 == 1 ? "Month" : "Months",
                                        color: .orange
                                    )
                                }
                                
                                if !formattedTimeRemaining.weeks.isEmpty {
                                    TimeUnitCard(
                                        value: String((daysRemaining % 30) / 7),
                                        unit: (daysRemaining % 30) / 7 == 1 ? "Week" : "Weeks",
                                        color: .purple
                                    )
                                }
                                
                                if !formattedTimeRemaining.days.isEmpty {
                                    TimeUnitCard(
                                        value: String((daysRemaining % 30) % 7),
                                        unit: (daysRemaining % 30) % 7 == 1 ? "Day" : "Days",
                                        color: .blue
                                    )
                                }
                            }
                            
                            Text("remaining")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                    } else if totalDaysInPeriod > 30 {
                        VStack(spacing: 15) {
                            HStack(spacing: 15) {
                                if !formattedTimeRemaining.weeks.isEmpty {
                                    TimeUnitCard(
                                        value: String(daysRemaining / 7),
                                        unit: daysRemaining / 7 == 1 ? "Week" : "Weeks",
                                        color: .purple
                                    )
                                }
                                
                                if !formattedTimeRemaining.days.isEmpty {
                                    TimeUnitCard(
                                        value: String(daysRemaining % 7),
                                        unit: daysRemaining % 7 == 1 ? "Day" : "Days",
                                        color: .blue
                                    )
                                }
                            }
                            
                            Text("remaining")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        VStack(spacing: 15) {
                            TimeUnitCard(
                                value: String(daysRemaining),
                                unit: daysRemaining == 1 ? "Day" : "Days",
                                color: .blue
                            )
                            
                            Text("remaining")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    DotVisualizationView(
                        totalDays: totalDaysInPeriod,
                        daysRemaining: daysRemaining
                    )
                }
                .padding(20)
                .background(
                    ZStack {
                        // Base glass-like background
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                        
                        // Subtle floral overlay
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.pink.opacity(0.05),
                                        Color.purple.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.5), Color.purple.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.purple.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
            } else {
                VStack(spacing: 10) {
                    Text("Event has passed")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.red, Color.red.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("\(-daysRemaining) days ago")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(20)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.red.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.5), Color.red.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.red.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditEvent = true
                }
                .foregroundColor(.blue)
            }
        }
        .sheet(isPresented: $showingEditEvent) {
            EditEventView(event: event, events: $events)
        }
    }
    
    private var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: event.date))
        return max(0, components.day ?? 0)
    }
    
    private var totalDaysInPeriod: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: event.date))
        return max(1, components.day ?? 1)
    }
    
    private var formattedTimeRemaining: (months: String, weeks: String, days: String) {
        let totalDays = daysRemaining
        
        if totalDays > 90 {
            let months = totalDays / 30
            let remainingDaysAfterMonths = totalDays % 30
            let weeks = remainingDaysAfterMonths / 7
            let days = remainingDaysAfterMonths % 7
            
            let monthsText = months > 0 ? "\(months) months" : ""
            let weeksText = weeks > 0 ? "\(weeks) weeks" : ""
            let daysText = days > 0 ? "\(days) days" : ""
            
            return (monthsText, weeksText, daysText)
        } else {
            let weeks = totalDays / 7
            let remainingDays = totalDays % 7
            
            let weeksText = weeks > 0 ? "\(weeks) weeks" : ""
            let daysText = remainingDays > 0 ? "\(remainingDays) days" : ""
            
            return ("", weeksText, daysText)
        }
    }
}

struct EditEventView: View {
    let event: Event
    @Binding var events: [Event]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventName: String
    @State private var eventDate: Date
    
    init(event: Event, events: Binding<[Event]>) {
        self.event = event
        self._events = events
        self._eventName = State(initialValue: event.name)
        self._eventDate = State(initialValue: event.date)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                FloralBackground()
                
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        Text("Edit Event")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Event Name")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter event name", text: $eventName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Target Date")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        DatePicker("Target Date", selection: $eventDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: saveEvent) {
                    Text("Save Changes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(eventName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(eventName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveEvent() {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].name = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
            events[index].date = eventDate
            saveEventsToUserDefaults()
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveEventsToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "events")
        }
    }
}

struct TimeUnitCard: View {
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text(unit)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
        .frame(minWidth: 60)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                // Base glass-like background
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                
                // Subtle color overlay
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.08), color.opacity(0.03)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [color.opacity(0.2), color.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: color.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct DotVisualizationView: View {
    let totalDays: Int
    let daysRemaining: Int
    
    private let columns = 10
    private let dotSize: CGFloat = 20
    private let spacing: CGFloat = 8
    
    // Calculate total units to display (weeks + days, or months + weeks + days)
    private var totalUnits: Int {
        if totalDays > 90 {
            let months = daysRemaining / 30
            let daysAfterMonths = daysRemaining % 30
            let weeks = daysAfterMonths / 7
            let days = daysAfterMonths % 7
            return months + weeks + days
        } else if totalDays > 30 {
            let weeks = daysRemaining / 7
            let days = daysRemaining % 7
            return weeks + days
        } else {
            return daysRemaining
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(dotSize), spacing: spacing), count: columns), spacing: spacing) {
                ForEach(0..<min(totalUnits, 365), id: \.self) { index in
                    Circle()
                        .fill(dotColor(for: index))
                        .frame(width: dotSize, height: dotSize)
                }
            }
            
            if totalDays > 365 {
                Text("\(totalDays - 365) more time units...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    private func dotColor(for index: Int) -> Color {
        if totalDays > 90 {
            // For periods > 90 days, show months, weeks, and days as units
            let months = daysRemaining / 30
            let daysAfterMonths = daysRemaining % 30
            let weeks = daysAfterMonths / 7
            let days = daysAfterMonths % 7
            
            if index < months {
                return .orange
            } else if index < months + weeks {
                return .purple
            } else {
                return .blue
            }
        } else if totalDays > 30 {
            // For periods > 30 days, show weeks and days as units
            let weeks = daysRemaining / 7
            let days = daysRemaining % 7
            
            if index < weeks {
                return .purple
            } else {
                return .blue
            }
        } else {
            // For periods <= 30 days, each dot represents 1 day
            return .blue
        }
    }
}

struct FloralBackground: View {
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.95, blue: 0.92),  // Warm white
                    Color(red: 0.95, green: 0.92, blue: 0.95),  // Light lavender
                    Color(red: 0.92, green: 0.95, blue: 0.92)   // Soft mint
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Subtle floral elements
            GeometryReader { geometry in
                // Large soft circles (petals)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.pink.opacity(0.05), Color.pink.opacity(0.01)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)
                    .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.15)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.purple.opacity(0.04), Color.purple.opacity(0.01)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.3)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.blue.opacity(0.03), Color.blue.opacity(0.01)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.7)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.orange.opacity(0.03), Color.orange.opacity(0.01)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 90
                        )
                    )
                    .frame(width: 180, height: 180)
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.8)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
