//
//  RouteItem.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 21/05/26.
//


import SwiftUI
import MapKit
import CoreLocation

// MARK: - Models & Support

struct RouteItem: Identifiable, Hashable {
    let id = UUID()
    let routeID: String
    let pickupName: String
    let pickupCoordinate: CLLocationCoordinate2D
    let dropoffName: String
    let dropoffCoordinate: CLLocationCoordinate2D
    var status: RouteStatus
    
    enum RouteStatus: String, CaseIterable {
        case pending = "Pending"
        case active = "Active"
        case completed = "Completed"
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .active: return .blue
            case .completed: return .green
            }
        }
    }
    
    static func == (lhs: RouteItem, rhs: RouteItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Core Live Location Services

@MainActor
class LocationTracker: NSObject,  CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var currentUserLocation: CLLocation?
    var heading: Double = 0.0
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    // Callback hook to let active route windows know the driver has physical movement updates
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 2.0 // Trigger calculations every 2 meters for accuracy
        locationManager.showsBackgroundLocationIndicator = true
        self.authorizationStatus = locationManager.authorizationStatus
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            startTracking()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentUserLocation = location
        onLocationUpdate?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy >= 0 {
            self.heading = newHeading.trueHeading
        }
    }
}

// MARK: - Main Dashboard View

struct AssignedRoutesListView: View {
    @State private var tracker = LocationTracker()
    @State private var selectedRoute: RouteItem?
    
    @State private var assignedRoutes = [
        RouteItem(
            routeID: "DISP-4022",
            pickupName: "ECC 15 (Employee Care Center 15)",
            pickupCoordinate: CLLocationCoordinate2D(latitude: 12.359922, longitude: 76.593254),
            dropoffName: "GEC 2 (Global Education Center 2)",
            dropoffCoordinate: CLLocationCoordinate2D(latitude: 12.352458, longitude: 76.596205),
            status: .active
        ),
        RouteItem(
            routeID: "DISP-9104",
            pickupName: "SFO Airport Air Freight Cargo",
            pickupCoordinate: CLLocationCoordinate2D(latitude: 37.6213, longitude: -122.3790),
            dropoffName: "Bay Area Distribution Center",
            dropoffCoordinate: CLLocationCoordinate2D(latitude: 37.7011, longitude: -122.1689),
            status: .pending
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if tracker.authorizationStatus == .notDetermined {
                        Button(action: { tracker.requestPermission() }) {
                            HStack {
                                Image(systemName: "location.circle.fill")
                                Text("Enable Live Navigation Tracking")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)
                    }
                    
                    ForEach(assignedRoutes) { route in
                        Button(action: {
                            selectedRoute = route
                        }) {
                            RouteCardView(route: route)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Assigned Routes")
            .sheet(item: $selectedRoute) { route in
                RouteDetailView(route: route, tracker: tracker)
            }
        }
    }
}

// MARK: - Route Detail View (With Active "Go Live" HUD UI)

struct RouteDetailView: View {
    let route: RouteItem
    var tracker: LocationTracker
    @Environment(\.dismiss) private var dismiss
    
    // Core Layout Navigation State Machine
    @State private var isTripActive = false
    @State private var currentStepInstruction: String = "Proceed to the highlighted route"
    @State private var nextManeuverIcon: String = "arrow.up.circle.fill"
    
    // Map Components
    @State private var position: MapCameraPosition = .automatic
    @State private var computedRoute: MKRoute?
    @State private var travelETA: String = "-- min"
    @State private var travelDistance: String = "-- mi"
    @State private var isLoadingRoute = false
    
    var body: some View {
        VStack(spacing: 0) {
            // LAYER 1: Turn-by-Turn Dynamic Banner Panel (Reveals exclusively when trip is Live)
            if isTripActive {
                HStack(spacing: 16) {
                    Image(systemName: nextManeuverIcon)
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(currentStepInstruction)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(2)
                        Text("Remaining: \(travelDistance)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    
                    Button(action: { stopNavigationHUD() }) {
                        Text("Exit")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                }
                .padding()
                .background(Color.blue)
                .transition(.move(edge: .top).combined(with: .opacity))
            } else {
                // Static Standard Header layout block
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(route.routeID)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Text("Route Overview Deck")
                            .font(.headline)
                    }
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
            
            // LAYER 2: Map Rendering Plane
            ZStack(alignment: .bottomTrailing) {
                Map(position: $position) {
                    if let userCoords = tracker.currentUserLocation?.coordinate {
                        Annotation("Driver Location", coordinate: userCoords) {
                            ZStack {
                                Circle().fill(.blue.opacity(0.2)).frame(width: 44, height: 44)
                                Circle().fill(.white).frame(width: 20, height: 20)
                                Circle().fill(.blue).frame(width: 14, height: 14)
                            }
                            .rotationEffect(.degrees(tracker.heading))
                        }
                    }
                    
                    Marker("Pickup Point", systemImage: "figure.wave", coordinate: route.pickupCoordinate)
                        .tint(.orange)
                    Marker("Drop-off Point", systemImage: "shippingbox.fill", coordinate: route.dropoffCoordinate)
                        .tint(.green)
                    
                    if let computedRoute {
                        MapPolyline(computedRoute.polyline)
                            .stroke(isTripActive ? .green : .blue, lineWidth: 6)
                    }
                }
                // Lock interactions out when active HUD runs to secure safety boundaries
                .allowsHitTesting(!isTripActive)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                
                if isLoadingRoute {
                    ProgressView()
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding()
                }
            }
            
            // LAYER 3: Dynamic Operations Execution Control Panel
            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    VStack(exclusiveAlignment: .leading) {
                        Text("ESTIMATED ETA")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Text(travelETA)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    
                    Divider().frame(height: 35)
                    
                    VStack(exclusiveAlignment: .leading) {
                        Text("REMAINING DISTANCE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Text(travelDistance)
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                if !isTripActive {
                    // Pre-trip Information Block Layout Element
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.green)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Delivery Destination Address")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                Text(route.dropoffName)
                                    .font(.body)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    
                    // Call to Action Master Toggle Interface
                    Button(action: { startNavigationHUD() }) {
                        Label("Start Journey & Go Live", systemImage: "bolt.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding([.horizontal, .bottom])
                } else {
                    // Core Live Operational controls interface layout elements
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Arrived & Confirm Delivery Receipt")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .background(Color(.systemBackground))
        }
        .task {
            await computeNavigationPolyline()
        }
        .onDisappear {
            // Tear down listener pipelines safely when dismiss cycles occur
            tracker.onLocationUpdate = nil
        }
    }
    
    // MARK: - Navigation Run Lifecycle

    // MARK: - Navigation Run Lifecycle

    // MARK: - Navigation Run Lifecycle

    private func startNavigationHUD() {
        withAnimation(.easeInOut) {
            isTripActive = true
        }
        
        // CORRECTED SYNTAX: Locks camera to vehicle position, tracks direction, handles fallback
        withAnimation {
            position = .userLocation(
                followsHeading: true,
                fallback: .automatic
            )
        }
        
        // Set up live pipeline event bindings handling processing mechanics directly
        tracker.onLocationUpdate = { activeLocation in
            Task {
                await evaluateReroutingMetrics(driverLocation: activeLocation)
            }
        }
    }

    private func stopNavigationHUD() {
        withAnimation(.easeInOut) {
            isTripActive = false
        }
        tracker.onLocationUpdate = nil
        if let computedRoute {
            withAnimation {
                position = .rect(computedRoute.polyline.boundingMapRect)
            }
        }
    }
    
    private func evaluateReroutingMetrics(driverLocation: CLLocation) async {
        guard let computedRoute else { return }
        
        // Quick math optimization evaluation processing paths checking deviation parameters
        let driverLocationPoint = MKMapPoint(driverLocation.coordinate)
        var minDistanceToPolyline: Double = .infinity
        
        // Check structural constraints loops against polyline metrics grids
        for i in 0..<computedRoute.polyline.pointCount {
            let point = computedRoute.polyline.points()[i]
            let distance = point.distance(to: driverLocationPoint)
            if distance < minDistanceToPolyline {
                minDistanceToPolyline = distance
            }
        }
        
        // Overhaul thresholds (If driver drifts past ~35 meters off-track, rebuild matching route lines automatically)
        if minDistanceToPolyline > 35.0 {
            print("Driver Deviation Event Captured. Recalculating Matrix Line Layers...")
            await computeNavigationPolyline()
        } else {
            // Update step text parameters incrementally matching nearest markers indices safely
            await parseNextDrivingManeuver(driverLocation: driverLocation)
        }
    }
    
    private func parseNextDrivingManeuver(driverLocation: CLLocation) async {
        guard let steps = computedRoute?.steps, !steps.isEmpty else { return }
        
        // Identify which turn-by-turn instruction segment the vehicle is currently tracking against
        for step in steps {
            let stepLocation = CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude)
            let distanceToStep = driverLocation.distance(from: stepLocation)
            
            // If approaching within 50 meters of the step junction vertex frame, surface instructions cleanly
            if distanceToStep < 50.0 && !step.instructions.isEmpty {
                self.currentStepInstruction = step.instructions
                self.nextManeuverIcon = selectManeuverSymbol(instructionText: step.instructions)
                break
            }
        }
    }
    
    private func selectManeuverSymbol(instructionText: String) -> String {
        let text = instructionText.lowercased()
        if text.contains("turn left") { return "arrow.turn.up.left.circle.fill" }
        if text.contains("turn right") { return "arrow.turn.up.right.circle.fill" }
        if text.contains("exit") { return "arrow.up.right.circle.fill" }
        if text.contains("merge") { return "arrow.triangle.merge.circle.fill" }
        return "arrow.up.circle.fill"
    }

    private func computeNavigationPolyline() async {
        isLoadingRoute = true
        let request = MKDirections.Request()
        
        if let userLocation = tracker.currentUserLocation?.coordinate {
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        } else {
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: route.pickupCoordinate))
        }
        
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: route.dropoffCoordinate))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        do {
            let response = try await directions.calculate()
            if let primaryRoute = response.routes.first {
                self.computedRoute = primaryRoute
                
                let minutes = Int(primaryRoute.expectedTravelTime / 60)
                self.travelETA = "\(minutes) mins"
                self.travelDistance = String(format: "%.1f mi", primaryRoute.distance / 1609.34)
                
                // Only reset bounding maps perspective frames if driver is pre-trip mode
                if !isTripActive {
                    let mapRect = primaryRoute.polyline.boundingMapRect
                    self.position = .rect(mapRect)
                }
            }
        } catch {
            print("Failed to calculate routing grid matrix: \(error.localizedDescription)")
            self.position = .region(MKCoordinateRegion(
                center: route.pickupCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        }
        isLoadingRoute = false
    }
}

// MARK: - Layout Alignment Helpers

private extension VStack {
    init(exclusiveAlignment: HorizontalAlignment, @ViewBuilder content: () -> Content) {
        self.init(alignment: exclusiveAlignment, spacing: nil, content: content)
    }
}

// MARK: - Subviews (Route List Card Component)

struct RouteCardView: View {
    let route: RouteItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(route.routeID)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .fontDesign(.monospaced)
                    .foregroundColor(.secondary)
                Spacer()
                Text(route.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(route.status.color.opacity(0.15))
                    .foregroundColor(route.status.color)
                    .clipShape(Capsule())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 10) {
                    Circle().fill(.orange).frame(width: 8, height: 8).padding(.top, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("PICKUP DOCK")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Text(route.pickupName)
                            .font(.body)
                            .lineLimit(1)
                    }
                }
                
                Capsule()
                    .fill(Color(.separator))
                    .frame(width: 2, height: 16)
                    .padding(.leading, 3)
                
                HStack(alignment: .top, spacing: 10) {
                    Circle().fill(.green).frame(width: 8, height: 8).padding(.top, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("DROPOFF DESTINATION")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Text(route.dropoffName)
                            .font(.body)
                            .lineLimit(1)
                    }
                }
            }
            
            HStack {
                Text("Tap to review routes & begin dispatch")
                    .font(.footnote)
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "arrow.up.right.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

// MARK: - Preview Rig

#Preview {
    AssignedRoutesListView()
}