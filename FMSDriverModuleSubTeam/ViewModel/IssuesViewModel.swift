//
//  IssuesViewModel.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 21/05/26.
//

import Foundation

@Observable
class IssuesViewModel{
    
    var searchText = ""
    
    var filteredIssues: [Issue] {
        
        if searchText.isEmpty {
            return issues
        }
        
        let query = searchText.lowercased()
        
        return issues.filter { issue in
            
            // Description
            
            let descriptionMatch =
            issue.defectDescription?
                .lowercased()
                .contains(query)
            ?? false
            
            // Inspection Type
            
            let typeMatch =
            issueHeader(for: issue.type)
                .lowercased()
                .contains(query)
            
            // Vehicle Number
            
            let vehicleMatch =
            vehicleNumber(for: issue.vehicleId)
                .lowercased()
                .contains(query)
            
            // Trip ID
            
            let tripMatch =
            issue.tripId.uuidString
                .lowercased()
                .contains(query)
            
            return descriptionMatch ||
                   typeMatch ||
                   vehicleMatch ||
                   tripMatch
        }
    }
    
    var issues: [Issue] = [
        
        Issue(
            id: UUID(),
            tripId: UUID(),
            vehicleId: UUID(),
            driverId: UUID(),
            type: .preTrip,
            checklist: InspectionChecklist(
                tyres: true,
                lights: true,
                brakes: false,
                fuel: true,
                mirrors: true,
                documents: true,
                bodyDamage: true
            ),
            defectFound: true,
            defectDescription: "Brake response felt delayed during pre-trip inspection.",
            photoUrls: [],
            createdAt: .now
        ),
        Issue(
            id: UUID(),
            tripId: UUID(),
            vehicleId: UUID(),
            driverId: UUID(),
            type: .preTrip,
            checklist: InspectionChecklist(
                tyres: true,
                lights: true,
                brakes: false,
                fuel: true,
                mirrors: true,
                documents: true,
                bodyDamage: true
            ),
            defectFound: true,
            defectDescription: "Brake pressure is too low.",
            photoUrls: [],
            createdAt: .now
        ),
        
        Issue(
            id: UUID(),
            tripId: UUID(),
            vehicleId: UUID(),
            driverId: UUID(),
            type: .during,
            checklist: InspectionChecklist(
                tyres: true,
                lights: true,
                brakes: true,
                fuel: false,
                mirrors: true,
                documents: true,
                bodyDamage: true
            ),
            defectFound: true,
            defectDescription: "Fuel level dropped unexpectedly during trip.",
            photoUrls: [],
            createdAt: .now
        ),
        
        Issue(
            id: UUID(),
            tripId: UUID(),
            vehicleId: UUID(),
            driverId: UUID(),
            type: .postTrip,
            checklist: InspectionChecklist(
                tyres: true,
                lights: true,
                brakes: true,
                fuel: true,
                mirrors: true,
                documents: true,
                bodyDamage: false
            ),
            defectFound: true,
            defectDescription: "Minor scratches detected on rear bumper after trip completion.",
            photoUrls: [],
            createdAt: .now
        )
    ]
    
    
    func issueHeader(
        for type: InspectionType
    ) -> String {
        
        switch type {
            
        case .preTrip:
            return "Pre Trip"
            
        case .during:
            return "During"
            
        case .postTrip:
            return "Post Trip"
        }
    }
    
    func vehicleNumber(
        for vehicleId: UUID
    ) -> String {
        
        // Temporary hardcoded mapping
        
        return "UP 80 AB 4587"
    }
}
