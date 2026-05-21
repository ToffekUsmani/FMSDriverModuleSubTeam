//
//  TripViewModel.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 22/05/26.
//

import Foundation

@Observable
class TripViewModel{
    
    var searchText = ""
    
    var filteredTrips: [Trip] {
        
        if searchText.isEmpty {
            return trips
        }
        
        let query = searchText.lowercased()
        
        return trips.filter { trip in
            
            // Route
            
            let startMatch =
            trip.startLocation
                .lowercased()
                .contains(query)
            
            let endMatch =
            trip.endLocation
                .lowercased()
                .contains(query)
            
            // Trip Number
            
            let tripIdMatch =
            trip.id.uuidString
                .lowercased()
                .contains(query)
            
            // Status
            
            let statusMatch =
            readableStatus(for: trip.status)
                .lowercased()
                .contains(query)
            
            // Notes
            
            let notesMatch =
            trip.notes?
                .lowercased()
                .contains(query)
            ?? false
            
            return startMatch ||
                   endMatch ||
                   tripIdMatch ||
                   statusMatch ||
                   notesMatch
        }
    }
    
    func readableStatus(
        for status: TripStatus
    ) -> String {
        
        switch status {
            
        case .notStarted:
            return "Upcoming"
            
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
    
    var trips: [Trip] = [
        // MARK: - Upcoming Trips
        Trip(
            id: UUID(),
            assignmentId: UUID(),
            vehicleId: UUID(),
            driverId: UUID(),
            plannedStartTime: .now.addingTimeInterval(3600 * 2),
            actualStartTime: nil,
            plannedEndTime: .now.addingTimeInterval(3600 * 6),
            actualEndTime: nil,
            startLocation: "Logistics Hub Alpha, Delhi",
            endLocation: "Distribution Center Omega, Gurugram",
            startLatitude: 28.6139,
            startLongitude: 77.2090,
            endLatitude: 28.4595,
            endLongitude: 77.0266,
            startOdometer: nil,
            endOdometer: nil,
            distanceKm: 42.5,
            routeGeojson: nil,
            status: .notStarted,
            delayReason: nil,
            notes: "Scheduled morning delivery.",
            createdAt: .now,
            updatedAt: .now
        ),
        
        Trip(
            id: UUID(),
            assignmentId: UUID(),
            vehicleId: UUID(),
            driverId: UUID(),
            plannedStartTime: .now.addingTimeInterval(3600 * 5),
            actualStartTime: nil,
            plannedEndTime: .now.addingTimeInterval(3600 * 10),
            actualEndTime: nil,
            startLocation: "Warehouse Sector 62, Noida",
            endLocation: "Retail Store Vega, Faridabad",
            startLatitude: 28.6280,
            startLongitude: 77.3649,
            endLatitude: 28.4089,
            endLongitude: 77.3178,
            startOdometer: nil,
            endOdometer: nil,
            distanceKm: 55.0,
            routeGeojson: nil,
            status: .notStarted,
            delayReason: nil,
            notes: "Fragile shipment.",
            createdAt: .now,
            updatedAt: .now
        ),
        
        // MARK: - Completed Trips
        
        Trip(
            id: UUID(),
            assignmentId: UUID(),
            vehicleId: UUID(),
            driverId: UUID(),
            plannedStartTime: .now.addingTimeInterval(-3600 * 10),
            actualStartTime: .now.addingTimeInterval(-3600 * 9),
            plannedEndTime: .now.addingTimeInterval(-3600 * 5),
            actualEndTime: .now.addingTimeInterval(-3600 * 4),
            startLocation: "Transport Yard Delhi",
            endLocation: "Hub Jaipur",
            startLatitude: 28.7041,
            startLongitude: 77.1025,
            endLatitude: 26.9124,
            endLongitude: 75.7873,
            startOdometer: 12450,
            endOdometer: 12790,
            distanceKm: 340.0,
            routeGeojson: nil,
            status: .completed,
            delayReason: nil,
            notes: "Trip completed successfully.",
            createdAt: .now,
            updatedAt: .now
        ),
        
        Trip(
            id: UUID(),
            assignmentId: UUID(),
            vehicleId: UUID(),
            driverId: UUID(),
            plannedStartTime: .now.addingTimeInterval(-3600 * 20),
            actualStartTime: .now.addingTimeInterval(-3600 * 19),
            plannedEndTime: .now.addingTimeInterval(-3600 * 14),
            actualEndTime: .now.addingTimeInterval(-3600 * 13),
            startLocation: "Lucknow Central Depot",
            endLocation: "Kanpur Delivery Point",
            startLatitude: 26.8467,
            startLongitude: 80.9462,
            endLatitude: 26.4499,
            endLongitude: 80.3319,
            startOdometer: 8900,
            endOdometer: 9025,
            distanceKm: 125.0,
            routeGeojson: nil,
            status: .completed,
            delayReason: nil,
            notes: "Delivered on time.",
            createdAt: .now,
            updatedAt: .now
        )
    ]
}
