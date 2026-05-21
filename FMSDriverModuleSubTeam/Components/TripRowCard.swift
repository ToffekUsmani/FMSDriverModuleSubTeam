import SwiftUI

struct TripRowCard: View {
    
    let trip: Trip
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            // MARK: - Icon
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .frame(width: 52, height: 52)
                
                Image(systemName: tripIcon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(iconColor)
            }
            
            // MARK: - Content
            
            VStack(alignment: .leading, spacing: 6) {
                
                HStack(spacing: 6) {
                    
                    // Temporary Trip Number
                    
                    Text(tripNumber)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.blue)
                    
                    Spacer()
                    
                    Text(statusText)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(statusColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(statusColor.opacity(0.12))
                        .clipShape(Capsule())
                }
                
                // Route
                
                Text("\(trip.startLocation) → \(trip.endLocation)")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                // Time
                
                HStack(spacing: 6) {
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    
                    Text(formattedTime)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.04), lineWidth: 0.5)
        )
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 4
        )
    }
}

// MARK: - Helpers

extension TripRowCard {
    
    var tripNumber: String {
        
        "TRP-\(trip.id.uuidString.prefix(4))"
    }
    
    var formattedTime: String {
        
        trip.plannedStartTime.formatted(
            .dateTime
                .hour()
                .minute()
        )
    }
    
    var statusText: String {
        
        switch trip.status {
            
        case .notStarted:
            return "Scheduled"
            
        case .ongoing:
            return "Ongoing"
            
        case .completed:
            return "Completed"
            
        case .delayed:
            return "Delayed"
            
        case .cancelled:
            return "Cancelled"
        }
    }
    
    var statusColor: Color {
        
        switch trip.status {
            
        case .notStarted:
            return .orange
            
        case .ongoing:
            return .blue
            
        case .completed:
            return .green
            
        case .delayed:
            return .red
            
        case .cancelled:
            return .gray
        }
    }
    
    var tripIcon: String {
        
        switch trip.status {
            
        case .notStarted:
            return "clock"
            
        case .ongoing:
            return "location.fill"
            
        case .completed:
            return "checkmark.circle.fill"
            
        case .delayed:
            return "exclamationmark.triangle.fill"
            
        case .cancelled:
            return "xmark.circle.fill"
        }
    }
    
    var iconColor: Color {
        
        switch trip.status {
            
        case .notStarted:
            return .orange
            
        case .ongoing:
            return .blue
            
        case .completed:
            return .green
            
        case .delayed:
            return .red
            
        case .cancelled:
            return .gray
        }
    }
}

// MARK: - Preview

#Preview {
    
    ZStack {
        
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        TripRowCard(
            trip: Trip(
                id: UUID(),
                assignmentId: UUID(),
                vehicleId: UUID(),
                driverId: UUID(),
                plannedStartTime: .now,
                actualStartTime: nil,
                plannedEndTime: .now.addingTimeInterval(3600),
                actualEndTime: nil,
                startLocation: "Delhi",
                endLocation: "Gurugram",
                startLatitude: nil,
                startLongitude: nil,
                endLatitude: nil,
                endLongitude: nil,
                startOdometer: nil,
                endOdometer: nil,
                distanceKm: 42,
                routeGeojson: nil,
                status: .notStarted,
                delayReason: nil,
                notes: nil,
                createdAt: .now,
                updatedAt: .now
            )
        )
        .padding()
    }
}
