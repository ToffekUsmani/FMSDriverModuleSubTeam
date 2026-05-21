import SwiftUI

struct TripsView: View {
    
    @State private var selectedTab: TripTab = .upcoming
    
    @State private var TripVM = TripViewModel()
    
    @State private var selectedTrip: Trip? = nil
    
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
                    
                    TextField("Search trips", text: $TripVM.searchText)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // MARK: - Trip List
                
                ScrollView{
                    
                    LazyVStack(spacing: 16) {
                        
                        if selectedTab == .upcoming {
                            
                            ForEach(
                                TripVM.filteredTrips.filter {
                                    $0.status == .notStarted
                                }
                            ) { trip in
                                
                                TripRowCard(trip: trip)
                                    .onTapGesture {
                                        
                                        selectedTrip = trip
                                    }
                            }
                            
                        } else {
                            
                            ForEach(TripVM.filteredTrips.filter{$0.status == .completed}){ trip in
                                TripRowCard(trip: trip)
                                    .onTapGesture {
                                            selectedTrip = trip
                                        }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding()
            .navigationDestination(
                item: $selectedTrip
            ) { trip in
                
                TripDetailView(trip: trip)
            }
            
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
