import SwiftUI

struct TripsView: View {
    
    @State private var selectedTab: TripTab = .upcoming
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 24) {
                
                
                // Title
                Text("My Trips")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 10)
                
                //Segmented Control
                
                Picker("", selection: $selectedTab) {
                    
                    Text("Upcoming")
                        .tag(TripTab.upcoming)
                    
                    Text("Completed")
                        .tag(TripTab.completed)
                }
                .pickerStyle(.segmented)
                
                // Search Bar
                
                HStack(spacing: 12) {
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    
                    TextField("Search trips", text: $searchText)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // MARK: - Trip List
                
                ScrollView{
                    
                    LazyVStack(spacing: 16) {
                        
                        if selectedTab == .upcoming {
                            
                            ForEach(0..<3, id: \.self) { _ in
                             TripRowCard()
                            }
                            
                        } else {
                            
                            ForEach(0..<2, id: \.self) { _ in
                                TripRowCard()
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding()
            
        }
    }
}



#Preview {
    TripsView()
}


// MARK: - Tabs

enum TripTab {
    case upcoming
    case completed
}
