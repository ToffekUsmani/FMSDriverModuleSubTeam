import SwiftUI
import MapKit

// MARK: - Core Data Models & Enums

enum DriverTab {
    case home
    case trips
    case maintenance
}

enum TripWorkflowState {
    case notStarted
    case preInspection
    case activeNavigation
    case postInspection
    case completed
}

struct HistoricalTrip: Identifiable {
    let id = UUID()
    let idString: String
    let startLocation: String
    let endLocation: String
    let date: String
    let isCompleted: Bool
}

struct MaintenanceIssue: Identifiable {
    let id = UUID()
    let category: String
    let description: String
    let priority: String
    let date: String
}

// MARK: - Main Application Container

struct DriverAppContainerView: View {
    @State private var selectedTab: DriverTab = .home
    @State private var workflowState: TripWorkflowState = .notStarted
    
    // Sample Data
    @State private var currentTripStart = "Logistics Hub Alpha, New Delhi"
    @State private var currentTripEnd = "Distribution Center Omega, Gurugram"
    
    @State private var historicalTrips = [
        HistoricalTrip(idString: "TRP-8821", startLocation: "Sector 62, Noida", endLocation: "Terminal 3, IGI Airport", date: "May 18, 2026", isCompleted: true),
        HistoricalTrip(idString: "TRP-9904", startLocation: "Okhla Phase III, Delhi", endLocation: "Udyog Vihar, Gurugram", date: "May 20, 2026", isCompleted: false),
        HistoricalTrip(idString: "TRP-9905", startLocation: "Logistics Hub Alpha, New Delhi", endLocation: "Tech Park, Bengaluru", date: "May 22, 2026", isCompleted: false)
    ]
    
    @State private var maintenanceIssues = [
        MaintenanceIssue(category: "Brakes", description: "Slight squealing noise when stopping from high speed.", priority: "Medium", date: "May 15, 2026"),
        MaintenanceIssue(category: "Engine", description: "Oil change indicator light turned on.", priority: "Low", date: "May 12, 2026")
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DriverHomeDashboardView(
                workflowState: $workflowState,
                startLocation: currentTripStart,
                endLocation: currentTripEnd,
                upcomingTrips: historicalTrips.filter { !$0.isCompleted }
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(DriverTab.home)
            
            TripsHistoryView(trips: historicalTrips)
                .tabItem {
                    Label("Trips", systemImage: "shippingbox.fill")
                }
                .tag(DriverTab.trips)
            
            MaintenanceReportView(issues: $maintenanceIssues)
                .tabItem {
                    Label("Maintenance", systemImage: "wrench.and.screwdriver.fill")
                }
                .tag(DriverTab.maintenance)
        }
        .accentColor(.blue)
    }
}

// MARK: - Tab 1: Home Dashboard View

struct DriverHomeDashboardView: View {
    @Binding var workflowState: TripWorkflowState
    let startLocation: String
    let endLocation: String
    let upcomingTrips: [HistoricalTrip]
    
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // 1. Header Section
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Date.now.formatted(date: .abbreviated, time: .omitted).uppercased())
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Text("Welcome, Driver")
                                .font(.title.bold())
                        }
                        Spacer()
                        Button {
                            showSettings.toggle()
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 38))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 2. Dynamic Workflow Card (Current Trip & Inspections)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Assignment")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Group {
                            switch workflowState {
                            case .notStarted:
                                InitialTripCard(start: startLocation, end: endLocation) {
                                    workflowState = .preInspection
                                }
                            case .preInspection:
                                InspectionChecklistView(title: "Pre-Trip Inspection", buttonTitle: "Confirm & Start Trip") {
                                    workflowState = .activeNavigation
                                }
                            case .activeNavigation:
                                ActiveNavigationCardView(start: startLocation, end: endLocation) {
                                    workflowState = .postInspection
                                }
                            case .postInspection:
                                InspectionChecklistView(title: "Post-Trip Inspection", buttonTitle: "Complete Workflow") {
                                    workflowState = .completed
                                }
                            case .completed:
                                TripCompletedCardView {
                                    workflowState = .notStarted // Reset mock state
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // 3. Upcoming Trips Sub-Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Upcoming Schedule")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if upcomingTrips.isEmpty {
                            Text("No upcoming trips assigned.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        } else {
                            ForEach(upcomingTrips) { trip in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(trip.idString)
                                            .font(.caption.bold())
                                            .foregroundColor(.blue)
                                        Text("\(trip.startLocation) → \(trip.endLocation)")
                                            .font(.subheadline.weight(.semibold))
                                        Text(trip.date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption.bold())
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $showSettings) {
                NavigationStack {
                    Text("Driver Profile & Settings")
                        .navigationTitle("Profile")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

// MARK: - Workflow Components

struct InitialTripCard: View {
    let start: String
    let end: String
    var onStartInspection: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("Assigned Run", systemImage: "truck.box.fill")
                    .font(.caption.bold())
                    .foregroundColor(.blue)
                Spacer()
                Text("Ready")
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            
            LocationTimelineView(start: start, end: end)
            
            Button(action: onStartInspection) {
                Text("Start Vehicle Inspection")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct InspectionChecklistView: View {
    let title: String
    let buttonTitle: String
    var onComplete: () -> Void
    
    @State private var checkedItems = [false, false, false, false]
    let items = ["Tyre Pressure & Tread Depth", "Fuel Level / Battery State", "Brake Function & Fluid", "Headlights & Signal Indicators"]
    
    var isAllChecked: Bool {
        !checkedItems.contains(false)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(.orange)
            
            ForEach(0..<items.count, id: \.self) { index in
                Toggle(isOn: $checkedItems[index]) {
                    Text(items[index])
                        .font(.body)
                }
                .toggleStyle(CheckboxToggleStyle())
            }
            
            Button(action: onComplete) {
                Text(buttonTitle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isAllChecked ? Color.green : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!isAllChecked)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct ActiveNavigationCardView: View {
    let start: String
    let end: String
    var onEndTrip: () -> Void
    
    @State private var showCommsSheet = false
    @State private var dummyRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("In Transit Navigation", systemImage: "location.fill")
                    .font(.caption.bold())
                    .foregroundColor(.green)
                Spacer()
                
                // Comms Button Panel
                Button {
                    showCommsSheet.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "message.fill")
                        Text("Dispatch Contact")
                    }
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            
            Map(coordinateRegion: $dummyRegion)
                .frame(height: 180)
                .cornerRadius(12)
            
            LocationTimelineView(start: start, end: end)
            
            Button(action: onEndTrip) {
                Text("End Trip")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .sheet(isPresented: $showCommsSheet) {
            CommunicationsPanelSheet()
        }
    }
}

struct TripCompletedCardView: View {
    var onReset: () -> Void
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)
            Text("Trip Successfully Completed")
                .font(.headline)
            Text("Your post-trip logs have been successfully submitted to dispatch control panels.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: onReset) {
                Text("Acknowledge & Clear")
                    .font(.subheadline.bold())
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

// MARK: - Tab 2: Combined Trips View (Upcoming & Completed)

struct TripsHistoryView: View {
    let trips: [HistoricalTrip]
    @State private var listSelection = 0 // 0: Upcoming, 1: Completed
    
    var filteredTrips: [HistoricalTrip] {
        if listSelection == 0 {
            return trips.filter { !$0.isCompleted }
        } else {
            return trips.filter { $0.isCompleted }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Trip Filter", selection: $listSelection) {
                    Text("Upcoming").tag(0)
                    Text("Completed").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                List(filteredTrips) { trip in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(trip.idString)
                                .font(.headline)
                            Spacer()
                            Text(trip.date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        LocationTimelineView(start: trip.startLocation, end: trip.endLocation)
                            .padding(.vertical, 4)
                    }
                    .listRowBackground(Color(.secondarySystemGroupedBackground))
                }
                .listStyle(.insetGrouped)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Trip Logs")
        }
    }
}

// MARK: - Tab 3: Maintenance View

struct MaintenanceReportView: View {
    @Binding var issues: [MaintenanceIssue]
    @State private var showRaiseIssueSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Reported Status Logs") {
                    if issues.isEmpty {
                        Text("No active maintenance reports submitted.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(issues) { issue in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(issue.category)
                                        .font(.headline)
                                    Text(issue.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Logged on: \(issue.date)")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(issue.priority)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(issue.priority == "High" ? Color.red.opacity(0.1) : Color.orange.opacity(0.1))
                                    .foregroundColor(issue.priority == "High" ? .red : .orange)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Vehicle Health")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showRaiseIssueSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showRaiseIssueSheet) {
                RaiseIssueSheet(issues: $issues)
            }
        }
    }
}

// MARK: - Modals & Helper Subviews

struct CommunicationsPanelSheet: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List {
                Section("Active Group Channels") {
                    NavigationLink(destination: ChatWindowView(title: "Fleet Operations Manager")) {
                        Label("Fleet Manager", systemImage: "person.2.wave.2.fill")
                    }
                    NavigationLink(destination: ChatWindowView(title: "Maintenance Depot Yard")) {
                        Label("Maintenance Support Teams", systemImage: "wrench.and.screwdriver.fill")
                    }
                }
            }
            .navigationTitle("Communications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

struct ChatWindowView: View {
    let title: String
    @State private var testText = ""
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Secure communication channel established with \(title).")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            HStack {
                TextField("Report an operational incident...", text: $testText)
                    .textFieldStyle(.roundedBorder)
                Button("Send") {}
            }
            .padding()
        }
        .navigationTitle(title)
    }
}

struct RaiseIssueSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var issues: [MaintenanceIssue]
    
    @State private var selectedCategory = "Engine"
    @State private var selectedPriority = "Medium"
    @State private var logsDescription = ""
    
    let categories = ["Engine", "Brakes", "Tyres", "Electrical", "Transmission", "Other"]
    let priorities = ["Low", "Medium", "High"]
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Component Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { Text($0) }
                }
                Picker("Operational Priority", selection: $selectedPriority) {
                    ForEach(priorities, id: \.self) { Text($0) }
                }
                Section("Fault Summary Details") {
                    TextField("Describe symptoms or component failures...", text: $logsDescription, axis: .vertical)
                        .lineLimit(4)
                }
            }
            .navigationTitle("Log New Failure")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        let newIssue = MaintenanceIssue(
                            category: selectedCategory,
                            description: logsDescription.isEmpty ? "No extended details provided." : logsDescription,
                            priority: selectedPriority,
                            date: Date.now.formatted(date: .abbreviated, time: .omitted)
                        )
                        issues.insert(newIssue, at: 0)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LocationTimelineView: View {
    let start: String
    let end: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "circle.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 14))
                Text(start)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "mappin.and.tail.rectangle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                Text(end)
                    .font(.subheadline)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Custom Styles

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .green : .secondary)
                    .font(.title3)
                configuration.label
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview Structural Rendering

#Preview {
    DriverAppContainerView()
}
