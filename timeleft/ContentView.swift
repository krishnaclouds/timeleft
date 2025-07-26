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
                
                Spacer()
                
                Button(action: {
                    showingAddEvent = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.blue)
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
                Text("\(daysUntil(event.date)) days")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(daysUntil(event.date) >= 0 ? .blue : .red)
                
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
}

struct AddEventView: View {
    @Binding var events: [Event]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventName = ""
    @State private var eventDate = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Text("Add New Event")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
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
                    Text("\(daysRemaining) days remaining")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    DotVisualizationView(
                        totalDays: totalDaysInPeriod,
                        daysRemaining: daysRemaining
                    )
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(15)
                .padding(.horizontal)
            } else {
                VStack(spacing: 10) {
                    Text("Event has passed")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    
                    Text("\(-daysRemaining) days ago")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(15)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: currentDate, to: event.date)
        return max(0, components.day ?? 0)
    }
    
    private var totalDaysInPeriod: Int {
        let calendar = Calendar.current
        let startOfCurrentDate = calendar.startOfDay(for: currentDate)
        let startOfEventDate = calendar.startOfDay(for: event.date)
        let components = calendar.dateComponents([.day], from: startOfCurrentDate, to: startOfEventDate)
        return max(1, components.day ?? 1)
    }
}

struct DotVisualizationView: View {
    let totalDays: Int
    let daysRemaining: Int
    
    private let columns = 10
    private let dotSize: CGFloat = 20
    private let spacing: CGFloat = 8
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(dotSize), spacing: spacing), count: columns), spacing: spacing) {
            ForEach(0..<totalDays, id: \.self) { index in
                Circle()
                    .fill(dotColor(for: index))
                    .frame(width: dotSize, height: dotSize)
            }
        }
        .padding()
    }
    
    private func dotColor(for index: Int) -> Color {
        let daysPassed = totalDays - daysRemaining
        if index < daysPassed {
            return .gray
        } else {
            return .blue
        }
    }
}

#Preview {
    ContentView()
}
