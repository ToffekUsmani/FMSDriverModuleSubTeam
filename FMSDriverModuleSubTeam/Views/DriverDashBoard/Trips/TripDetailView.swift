//
//  TripDetailView.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 22/05/26.
//


import SwiftUI

struct TripDetailView: View {
    
    let trip: Trip
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 18) {
                
                // MARK: - Hero Section
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text("\(trip.startLocation) → \(trip.endLocation)")
                        .font(.system(size: 24, weight: .bold))
                    
                    HStack(spacing: 8) {
                        
                        Image(systemName: statusIcon)
                            .foregroundStyle(statusColor)
                        
                        Text("\(statusTitle) • \(statusDate)")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
                
                // MARK: - Metrics
                
                HStack(spacing: 12) {
                    
                    metricCard(
                        icon: leftMetricIcon,
                        value: leftMetricValue,
                        title: leftMetricTitle,
                        color: leftMetricColor
                    )
                    
                    metricCard(
                        icon: centerMetricIcon,
                        value: centerMetricValue,
                        title: centerMetricTitle,
                        color: centerMetricColor
                    )
                    
                    metricCard(
                        icon: statusIcon,
                        value: statusShortText,
                        title: "Status",
                        color: statusColor
                    )
                }
                
                // MARK: - Trip Information
                
                VStack(alignment: .leading, spacing: 18) {
                    
                    Text("Trip Information")
                        .font(.title3.bold())
                    
                    detailRow(
                        title: "Trip ID",
                        value: "TRP-\(trip.id.uuidString.prefix(6))"
                    )
                    
                    detailRow(
                        title: "Origin",
                        value: trip.startLocation
                    )
                    
                    detailRow(
                        title: "Destination",
                        value: trip.endLocation
                    )
                    
                    if trip.status == .completed {
                        
                        detailRow(
                            title: "Started At",
                            value: startedTime
                        )
                        
                        detailRow(
                            title: "Completed At",
                            value: completedTime
                        )
                        
                    } else {
                        
                        detailRow(
                            title: "Planned Start",
                            value: plannedTime
                        )
                    }
                    
                    if let notes = trip.notes,
                       !notes.isEmpty {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text("Notes")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            Text(notes)
                                .font(.body)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(18)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay {
                    
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.black.opacity(0.04))
                }
                .shadow(
                    color: .black.opacity(0.04),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Components

extension TripDetailView {
    
    func metricCard(
        icon: String,
        value: String,
        title: String,
        color: Color
    ) -> some View {
        
        VStack(spacing: 6) {
            
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            
            Text(value)
                .font(.headline.bold())
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.04))
        }
    }
    
    func detailRow(
        title: String,
        value: String
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 4) {
            
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.body.weight(.semibold))
        }
    }
}

// MARK: - Helpers

extension TripDetailView {
    
    var isCompleted: Bool {
        trip.status == .completed
    }
    
    var navigationTitle: String {
        isCompleted ? "Completed Trip" : "Upcoming Trip"
    }
    
    var statusTitle: String {
        isCompleted ? "Completed" : "Scheduled"
    }
    
    var statusShortText: String {
        isCompleted ? "Done" : "Upcoming"
    }
    
    var statusIcon: String {
        isCompleted
        ? "checkmark.circle.fill"
        : "clock.fill"
    }
    
    var statusColor: Color {
        isCompleted ? .green : .orange
    }
    
    var statusDate: String {
        
        isCompleted
        ? completedDate
        : plannedDate
    }
    
    // MARK: - Left Metric
    
    var leftMetricIcon: String {
        
        isCompleted
        ? "road.lanes"
        : "calendar"
    }
    
    var leftMetricValue: String {
        
        isCompleted
        ? "\(trip.distanceKm ?? 0, default: "%.0f") km"
        : plannedTime
    }
    
    var leftMetricTitle: String {
        
        isCompleted
        ? "Distance"
        : "Start Time"
    }
    
    var leftMetricColor: Color {
        
        isCompleted
        ? .blue
        : .blue
    }
    
    // MARK: - Center Metric
    
    var centerMetricIcon: String {
        
        isCompleted
        ? "clock.fill"
        : "road.lanes"
    }
    
    var centerMetricValue: String {
        
        isCompleted
        ? tripDuration
        : "\(trip.distanceKm ?? 0, default: "%.0f") km"
    }
    
    var centerMetricTitle: String {
        
        isCompleted
        ? "Duration"
        : "Distance"
    }
    
    var centerMetricColor: Color {
        
        isCompleted
        ? .orange
        : .orange
    }
    
    // MARK: - Dates
    
    var completedDate: String {
        
        trip.actualEndTime?.formatted(
            .dateTime
                .day()
                .month(.abbreviated)
                .year()
        ) ?? "-"
    }
    
    var plannedDate: String {
        
        trip.plannedStartTime.formatted(
            .dateTime
                .day()
                .month(.abbreviated)
                .year()
        )
    }
    
    var plannedTime: String {
        
        trip.plannedStartTime.formatted(
            .dateTime
                .hour()
                .minute()
        )
    }
    
    var startedTime: String {
        
        trip.actualStartTime?.formatted(
            .dateTime
                .hour()
                .minute()
        ) ?? "-"
    }
    
    var completedTime: String {
        
        trip.actualEndTime?.formatted(
            .dateTime
                .hour()
                .minute()
        ) ?? "-"
    }
    
    var tripDuration: String {
        
        guard
            let start = trip.actualStartTime,
            let end = trip.actualEndTime
        else {
            return "-"
        }
        
        let interval = end.timeIntervalSince(start)
        
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        return "\(hours)h \(minutes)m"
    }
}

// MARK: - Preview

#Preview {
    
    NavigationStack {
        
        TripDetailView(
            trip: Trip(
                id: UUID(),
                assignmentId: UUID(),
                vehicleId: UUID(),
                driverId: UUID(),
                plannedStartTime: .now.addingTimeInterval(3600 * 2),
                actualStartTime: .now.addingTimeInterval(-3600 * 5),
                plannedEndTime: .now,
                actualEndTime: .now,
                startLocation: "Delhi",
                endLocation: "Jaipur",
                startLatitude: nil,
                startLongitude: nil,
                endLatitude: nil,
                endLongitude: nil,
                startOdometer: 12000,
                endOdometer: 12340,
                distanceKm: 340,
                routeGeojson: nil,
                status: .completed,
                delayReason: nil,
                notes: "Trip completed successfully without any delay.",
                createdAt: .now,
                updatedAt: .now
            )
        )
    }
}
