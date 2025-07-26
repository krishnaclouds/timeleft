//
//  ContentView.swift
//  timeleft
//
//  Created by Bala Krishna on 25/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var currentDate = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Time Left")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                VStack(spacing: 15) {
                    Text("Select Target Date")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    DatePicker("Target Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding(.horizontal)
                }
                
                if selectedDate > currentDate {
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
                    Text("Please select a future date")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    private var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: currentDate, to: selectedDate)
        return max(0, components.day ?? 0)
    }
    
    private var totalDaysInPeriod: Int {
        let calendar = Calendar.current
        let startOfCurrentDate = calendar.startOfDay(for: currentDate)
        let startOfSelectedDate = calendar.startOfDay(for: selectedDate)
        let components = calendar.dateComponents([.day], from: startOfCurrentDate, to: startOfSelectedDate)
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
