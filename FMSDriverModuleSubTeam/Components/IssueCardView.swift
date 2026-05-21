import SwiftUI

struct IssueCardView: View {
    
    let issue: Issue = Issue(
        id: UUID(),
        tripId: UUID(),
        vehicleId: UUID(),
        driverId: UUID(),
        type: .during,
        checklist: InspectionChecklist(),
        defectFound: true,
        defectDescription: "Brake response felt delayed during inspection.",
        photoUrls: [],
        createdAt: .now
    )
    
    // Temporary hardcoded vehicle number will fetch it from vechile table by using vechile.id
    let vehicleNumber = "UP 80 AB 4587"
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - Top Section
            
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(issueTypeTitle)
                        .font(.headline)
                    
                    Text(formattedDate)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                Text(issue.defectFound ? "Issue Found" : "Passed")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(
                        issue.defectFound ? .orange : .green
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(
                        (issue.defectFound ? Color.orange : Color.green)
                            .opacity(0.14)
                    )
                    .clipShape(Capsule())
                
                
            }
            
            Divider()
            
            // MARK: - Details
            
            VStack(spacing: 12) {
                
                //trip id
                HStack {
                    
                    Text("Trip ID")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(issue.tripId.uuidString.prefix(12) + "...")
                        .fontWeight(.medium)
                }
                .font(.subheadline)
                
                //vechicle no.
                HStack {
                    
                    Text("Vehicle No.")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(vehicleNumber)
                        .fontWeight(.medium)
                }
                .font(.subheadline)
                
                
            }
            
            // MARK: - Description
            
            if let description = issue.defectDescription,
               !description.isEmpty {
                
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("Description")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    
                    Text(description)
                        .font(.body)
                }
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.black.opacity(0.05))
        }
        .shadow(
            color: .black.opacity(0.04),
            radius: 10,
            x: 0,
            y: 4
        )
    }
}
#Preview {
    
    
    IssueCardView()
        .padding()
    
    
}
// MARK: - Helpers

extension IssueCardView {
    
    var issueTypeTitle: String {
        
        switch issue.type {
            
        case .preTrip:
            return "Pre-Trip Inspection"
            
        case .postTrip:
            return "Post-Trip Inspection"
            
        case .during:
            return "During Trip"
        }
    }
    
    
    
    var formattedDate: String {
        
        issue.createdAt.formatted(
            .dateTime
                .day()
                .month(.abbreviated)
                .year()
        )
    }
}
