//
//  DataModel.swift
//  FMSApp
//
//  Created by Onkar Dureja on 19/05/26.
//

import Foundation

// =============================================================================
// MARK: - Enums
// =============================================================================

public enum UserRole: String, Codable, CaseIterable, Hashable {
    case fleetManager = "fleet_manager"
    case driver
    case maintenance

    public var displayName: String {
        switch self {
        case .fleetManager: return "Fleet Manager"
        case .driver:       return "Driver"
        case .maintenance:  return "Maintenance Personnel"
        }
    }
}

public enum FuelType: String, Codable, CaseIterable, Hashable {
    case petrol
    case diesel
    case cng
    case electric = "ev"

    public var displayName: String {
        switch self {
        case .petrol:   return "Petrol"
        case .diesel:   return "Diesel"
        case .cng:      return "CNG"
        case .electric: return "Electric"
        }
    }
}

public enum VehicleType: String, Codable, CaseIterable, Hashable {
    case truck
    case van
    case miniTruck = "mini_truck"
    case car
    case bike
}

public enum VehicleStatus: String, Codable, CaseIterable, Hashable {
    case active
    case inactive
    case inMaintenance = "in_maintenance"
    case onTrip        = "on_trip"
}

public enum TripStatus: String, Codable, CaseIterable, Hashable {
    case notStarted = "not_started"
    case ongoing
    case completed
    case delayed
    case cancelled
}

//MARK: - i changed here
public enum InspectionType: String, Codable, CaseIterable, Hashable {
    case preTrip  = "pre_trip"
    case during = "during"
    case postTrip = "post_trip"
}

public enum WorkOrderStatus: String, Codable, CaseIterable, Hashable {
    case toDo       = "to_do"
    case inProgress = "in_progress"
    case onHold     = "on_hold"
    case completed
}

public enum WorkOrderPriority: String, Codable, CaseIterable, Hashable {
    case low
    case medium
    case high
    case urgent
}

public enum NotificationCategory: String, Codable, CaseIterable, Hashable {
    case trip
    case workOrder  = "work_order"
    case geofence
    case compliance
    case fuel
    case message
    case system
}

public enum GeofenceEventType: String, Codable, CaseIterable, Hashable {
    case enter
    case exit
}

public enum ChatType: String, Codable, CaseIterable, Hashable {
    case oneToOne  = "one_to_one"
    case group
    case broadcast
}

public enum ComplianceStatus: String, Codable, CaseIterable, Hashable {
    case green
    case amber
    case red
}

// =============================================================================
// MARK: - AppUser
// =============================================================================

/// Application-level user profile. Linked to Supabase auth.users via `authId`.
/// We never store passwords here — Supabase Auth handles credentials.
public struct AppUser: Codable, Identifiable, Hashable {
    public let id: UUID
    public let authId: UUID?
    public var fullName: String
    public let email: String
    public var phoneNumber: String?
    public var role: UserRole
    public var profileImageUrl: String?
    public var isActive: Bool
    public let createdAt: Date
    public var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case authId           = "auth_id"
        case fullName         = "full_name"
        case email
        case phoneNumber      = "phone_number"
        case role
        case profileImageUrl  = "profile_image_url"
        case isActive         = "is_active"
        case createdAt        = "created_at"
        case updatedAt        = "updated_at"
    }
}

// =============================================================================
// MARK: - Vehicle
// =============================================================================

public struct Vehicle: Codable, Identifiable, Hashable {
    public let id: UUID
    public var registrationNumber: String      // license plate
    public let vin: String                     // immutable once set
    public var make: String
    public var model: String
    public var year: Int
    public var vehicleType: VehicleType
    public var fuelType: FuelType
    public var fuelCapacityLitres: Double
    public var loadCapacityKg: Double
    public var mileageKmPerLitre: Double
    public var odometerReading: Int
    public var insuranceExpiry: Date?
    public var pucExpiry: Date?
    public var lastServiceDate: Date?
    public var nextServiceDueDate: Date?
    public var healthScore: Int?               // 0–100, AI-computed
    public var status: VehicleStatus
    public var isActive: Bool
    public let createdAt: Date
    public var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case registrationNumber  = "registration_number"
        case vin
        case make
        case model
        case year
        case vehicleType         = "vehicle_type"
        case fuelType            = "fuel_type"
        case fuelCapacityLitres  = "fuel_capacity_litres"
        case loadCapacityKg      = "load_capacity_kg"
        case mileageKmPerLitre   = "mileage_km_per_litre"
        case odometerReading     = "odometer_reading"
        case insuranceExpiry     = "insurance_expiry"
        case pucExpiry           = "puc_expiry"
        case lastServiceDate     = "last_service_date"
        case nextServiceDueDate  = "next_service_due_date"
        case healthScore         = "health_score"
        case status
        case isActive            = "is_active"
        case createdAt           = "created_at"
        case updatedAt           = "updated_at"
    }

    /// Computed compliance status based on document expiry dates.
    /// Green: all docs valid for 30+ days.
    /// Amber: at least one doc expires in next 30 days.
    /// Red:   at least one doc expired or expires within 7 days.
    public var complianceStatus: ComplianceStatus {
        let now = Date()
        let sevenDays  = Calendar.current.date(byAdding: .day, value: 7,  to: now) ?? now
        let thirtyDays = Calendar.current.date(byAdding: .day, value: 30, to: now) ?? now

        let documents: [Date?] = [insuranceExpiry, pucExpiry, nextServiceDueDate]
        for date in documents.compactMap({ $0 }) {
            if date < sevenDays  { return .red }
        }
        for date in documents.compactMap({ $0 }) {
            if date < thirtyDays { return .amber }
        }
        return .green
    }
}

// =============================================================================
// MARK: - Assignment
// =============================================================================

/// Driver ↔ Vehicle pairing for a time window.
/// An "active" assignment is one with `isActive = true` and no `endTime`.
public struct Assignment: Codable, Identifiable, Hashable {
    public let id: UUID
    public let vehicleId: UUID
    public let driverId: UUID
    public var startTime: Date
    public var endTime: Date?
    public var isActive: Bool
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case vehicleId  = "vehicle_id"
        case driverId   = "driver_id"
        case startTime  = "start_time"
        case endTime    = "end_time"
        case isActive   = "is_active"
        case createdAt  = "created_at"
    }
}

// =============================================================================
// MARK: - Trip
// =============================================================================

public struct Trip: Codable, Identifiable, Hashable {
    public let id: UUID
    public let assignmentId: UUID?
    public let vehicleId: UUID
    public let driverId: UUID
    public var plannedStartTime: Date
    public var actualStartTime: Date?
    public var plannedEndTime: Date?
    public var actualEndTime: Date?
    public var startLocation: String
    public var endLocation: String
    public var startLatitude: Double?
    public var startLongitude: Double?
    public var endLatitude: Double?
    public var endLongitude: Double?
    public var startOdometer: Int?
    public var endOdometer: Int?
    public var distanceKm: Double?
    public var routeGeojson: String?           // JSON-encoded LineString
    public var status: TripStatus
    public var delayReason: String?
    public var notes: String?
    public let createdAt: Date
    public var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case assignmentId     = "assignment_id"
        case vehicleId        = "vehicle_id"
        case driverId         = "driver_id"
        case plannedStartTime = "planned_start_time"
        case actualStartTime  = "actual_start_time"
        case plannedEndTime   = "planned_end_time"
        case actualEndTime    = "actual_end_time"
        case startLocation    = "start_location"
        case endLocation      = "end_location"
        case startLatitude    = "start_latitude"
        case startLongitude   = "start_longitude"
        case endLatitude      = "end_latitude"
        case endLongitude     = "end_longitude"
        case startOdometer    = "start_odometer"
        case endOdometer      = "end_odometer"
        case distanceKm       = "distance_km"
        case routeGeojson     = "route_geojson"
        case status
        case delayReason      = "delay_reason"
        case notes
        case createdAt        = "created_at"
        case updatedAt        = "updated_at"
    }
}

// =============================================================================
// MARK: - Inspection
// =============================================================================

public struct InspectionChecklist: Codable, Hashable {
    public var tyres: Bool
    public var lights: Bool
    public var brakes: Bool
    public var fuel: Bool
    public var mirrors: Bool
    public var documents: Bool
    public var bodyDamage: Bool

    public init(tyres: Bool = false, lights: Bool = false, brakes: Bool = false,
                fuel: Bool = false, mirrors: Bool = false,
                documents: Bool = false, bodyDamage: Bool = false) {
        self.tyres = tyres; self.lights = lights; self.brakes = brakes
        self.fuel = fuel; self.mirrors = mirrors
        self.documents = documents; self.bodyDamage = bodyDamage
    }

    public var allPassed: Bool {
        tyres && lights && brakes && fuel && mirrors && documents && bodyDamage
    }
}

//MARK: - i changed here
public struct Issue: Codable, Identifiable, Hashable {
    public let id: UUID
    public let tripId: UUID
    public let vehicleId: UUID
    public let driverId: UUID
    public var type: InspectionType
    public var checklist: InspectionChecklist
    public var defectFound: Bool
    public var defectDescription: String?
    public var photoUrls: [String]
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case tripId             = "trip_id"
        case vehicleId          = "vehicle_id"
        case driverId           = "driver_id"
        case type
        case checklist
        case defectFound        = "defect_found"
        case defectDescription  = "defect_description"
        case photoUrls          = "photo_urls"
        case createdAt          = "created_at"
    }
}

// =============================================================================
// MARK: - Fuel Entry
// =============================================================================

public struct FuelEntry: Codable, Identifiable, Hashable {
    public let id: UUID
    public let vehicleId: UUID
    public let driverId: UUID
    public let tripId: UUID?
    public var litres: Double
    public var costPerLitre: Double
    public var totalCost: Double
    public var odometerReading: Int
    public var location: String?
    public var receiptPhotoUrl: String?
    public var timestamp: Date
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case vehicleId          = "vehicle_id"
        case driverId           = "driver_id"
        case tripId             = "trip_id"
        case litres
        case costPerLitre       = "cost_per_litre"
        case totalCost          = "total_cost"
        case odometerReading    = "odometer_reading"
        case location
        case receiptPhotoUrl    = "receipt_photo_url"
        case timestamp
        case createdAt          = "created_at"
    }
}

// =============================================================================
// MARK: - Work Order
// =============================================================================

public struct WorkOrder: Codable, Identifiable, Hashable {
    public let id: UUID
    public let vehicleId: UUID
    public let createdById: UUID
    public var assignedToId: UUID?
    public var title: String
    public var description: String
    public var photoUrls: [String]
    public var status: WorkOrderStatus
    public var priority: WorkOrderPriority
    public var aiPriorityScore: Double?         // 0.0 – 1.0
    public var aiPriorityReason: String?
    public var labourHours: Double?
    public var labourCost: Double?
    public var partsCost: Double?
    public let totalCost: Double?               // GENERATED column (DB-computed)
    public let createdAt: Date
    public var startedAt: Date?
    public var completedAt: Date?
    public var onHoldReason: String?
    public var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case vehicleId         = "vehicle_id"
        case createdById       = "created_by_id"
        case assignedToId      = "assigned_to_id"
        case title
        case description
        case photoUrls         = "photo_urls"
        case status
        case priority
        case aiPriorityScore   = "ai_priority_score"
        case aiPriorityReason  = "ai_priority_reason"
        case labourHours       = "labour_hours"
        case labourCost        = "labour_cost"
        case partsCost         = "parts_cost"
        case totalCost         = "total_cost"
        case createdAt         = "created_at"
        case startedAt         = "started_at"
        case completedAt       = "completed_at"
        case onHoldReason      = "on_hold_reason"
        case updatedAt         = "updated_at"
    }
}

// =============================================================================
// MARK: - Spare Part
// =============================================================================

public struct SparePart: Codable, Identifiable, Hashable {
    public let id: UUID
    public var name: String
    public var sku: String
    public var category: String?
    public var stockCount: Int
    public var unitCost: Double
    public var lowStockThreshold: Int
    public var supplier: String?
    public var aiForecastNext7Days: Int?
    public var aiForecastNext30Days: Int?
    public var isActive: Bool
    public let createdAt: Date
    public var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sku
        case category
        case stockCount             = "stock_count"
        case unitCost               = "unit_cost"
        case lowStockThreshold      = "low_stock_threshold"
        case supplier
        case aiForecastNext7Days    = "ai_forecast_next_7_days"
        case aiForecastNext30Days   = "ai_forecast_next_30_days"
        case isActive               = "is_active"
        case createdAt              = "created_at"
        case updatedAt              = "updated_at"
    }

    public var isLowStock: Bool {
        stockCount <= lowStockThreshold
    }
}

// =============================================================================
// MARK: - Part Usage (junction: WorkOrder ↔ SparePart)
// =============================================================================

public struct PartUsage: Codable, Identifiable, Hashable {
    public let id: UUID
    public let workOrderId: UUID
    public let partId: UUID
    public var quantityUsed: Int
    public var unitCostAtTimeOfUse: Double      // snapshot price
    public let totalCost: Double                // GENERATED column
    public var usedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case workOrderId          = "work_order_id"
        case partId               = "part_id"
        case quantityUsed         = "quantity_used"
        case unitCostAtTimeOfUse  = "unit_cost_at_time_of_use"
        case totalCost            = "total_cost"
        case usedAt               = "used_at"
    }
}

// =============================================================================
// MARK: - Geofence
// =============================================================================

public struct Geofence: Codable, Identifiable, Hashable {
    public let id: UUID
    public var name: String
    public var centerLatitude: Double
    public var centerLongitude: Double
    public var radiusMetres: Int
    public var isActive: Bool
    public let createdById: UUID
    public let createdAt: Date
    public var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case centerLatitude   = "center_latitude"
        case centerLongitude  = "center_longitude"
        case radiusMetres     = "radius_metres"
        case isActive         = "is_active"
        case createdById      = "created_by_id"
        case createdAt        = "created_at"
        case updatedAt        = "updated_at"
    }
}

// =============================================================================
// MARK: - Geofence Event
// =============================================================================

public struct GeofenceEvent: Codable, Identifiable, Hashable {
    public let id: UUID
    public let geofenceId: UUID
    public let vehicleId: UUID
    public let driverId: UUID?
    public let tripId: UUID?
    public var eventType: GeofenceEventType
    public var latitude: Double
    public var longitude: Double
    public var acknowledged: Bool
    public var acknowledgedBy: UUID?
    public var acknowledgedAt: Date?
    public var acknowledgmentNote: String?
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case geofenceId           = "geofence_id"
        case vehicleId            = "vehicle_id"
        case driverId             = "driver_id"
        case tripId               = "trip_id"
        case eventType            = "event_type"
        case latitude
        case longitude
        case acknowledged
        case acknowledgedBy       = "acknowledged_by"
        case acknowledgedAt       = "acknowledged_at"
        case acknowledgmentNote   = "acknowledgment_note"
        case createdAt            = "created_at"
    }
}

// =============================================================================
// MARK: - Chat & Messaging
// =============================================================================

public struct Chat: Codable, Identifiable, Hashable {
    public let id: UUID
    public var type: ChatType
    public var title: String?
    public var tripId: UUID?
    public let createdAt: Date
    public var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case tripId     = "trip_id"
        case createdAt  = "created_at"
        case updatedAt  = "updated_at"
    }
}

public struct ChatParticipant: Codable, Identifiable, Hashable {
    public let id: UUID
    public let chatId: UUID
    public let userId: UUID
    public let joinedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case chatId    = "chat_id"
        case userId    = "user_id"
        case joinedAt  = "joined_at"
    }
}

public struct Message: Codable, Identifiable, Hashable {
    public let id: UUID
    public let chatId: UUID
    public let senderId: UUID
    public var content: String
    public var attachmentUrl: String?
    public var isRead: Bool
    public let sentAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case chatId         = "chat_id"
        case senderId       = "sender_id"
        case content
        case attachmentUrl  = "attachment_url"
        case isRead         = "is_read"
        case sentAt         = "sent_at"
    }
}

// =============================================================================
// MARK: - App Notification (in-app notification center)
// =============================================================================

public struct NotificationMetadata: Codable, Hashable {
    public var entityType: String?           // "trip" | "work_order" | "geofence" | "vehicle"
    public var entityId: String?
    public var priority: String?             // "high" | "medium" | "low"

    enum CodingKeys: String, CodingKey {
        case entityType = "entity_type"
        case entityId   = "entity_id"
        case priority
    }
}

public struct AppNotification: Codable, Identifiable, Hashable {
    public let id: UUID
    public let userId: UUID
    public var category: NotificationCategory
    public var title: String
    public var body: String
    public var deepLinkPath: String?
    public var metadata: NotificationMetadata?
    public var isRead: Bool
    public var readAt: Date?
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId        = "user_id"
        case category
        case title
        case body
        case deepLinkPath  = "deep_link_path"
        case metadata
        case isRead        = "is_read"
        case readAt        = "read_at"
        case createdAt     = "created_at"
    }
}
