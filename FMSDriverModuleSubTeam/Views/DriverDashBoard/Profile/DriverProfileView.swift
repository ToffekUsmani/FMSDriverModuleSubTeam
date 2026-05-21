import SwiftUI

struct DriverProfileView: View {
    
    // MARK: - Temp Driver
    
    let driver = AppUser(
        id: UUID(),
        authId: UUID(),
        fullName: "Vikram Singh",
        email: "vikram.singh@fleetmail.com",
        phoneNumber: "+91 91234 56789",
        role: .driver,
        profileImageUrl: nil,
        isActive: true,
        createdAt: .now,
        updatedAt: .now
    )
    
    var body: some View {
        
        
        
        ScrollView{
            
            VStack(spacing: 28) {
                
                // MARK: - Profile Section
                
                VStack(spacing: 16) {
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        // Profile Image
                        Image(.driverSProfile)
                        //                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.blue)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                        
                        // Verified Badge
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title)
                            .foregroundStyle(.blue)
                            .clipShape(Circle())
                    }
                    
                    VStack(spacing: 6) {
                        
                        Text(driver.fullName)
                            .font(.system(size: 38, weight: .bold))
                        
                        Text("Fleet Driver")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    
                    
                }
                
                // MARK: - Stats
                
                HStack(spacing: 16) {
                    
                    //total trips
                    VStack(spacing: 10) {
                        Text("Trips")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("123")
                            .font(.title2.bold())
                            .foregroundStyle(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(
                        color: .black.opacity(0.04),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                    
                    //total hours
                    VStack(spacing: 10) {
                        
                        Text("Hours")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text("2,450h")
                            .font(.title2.bold())
                            .foregroundStyle(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(
                        color: .black.opacity(0.04),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                    
                    //total distance
                    VStack(spacing: 10) {
                        
                        Text("DIST.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text("124.5K")
                            .font(.title2.bold())
                            .foregroundStyle(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(
                        color: .black.opacity(0.04),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                    
                    
                }
                
                // MARK: - Settings
                
                VStack(alignment: .leading, spacing: 18) {
                    
                    
                    Text("Settings")
                        .font(.system(size: 25, weight: .bold))
                    
                    VStack(spacing: 0) {
                        
                        NavigationLink {
                            
                            EditPersonalInfoView(driver: driver)
                            
                        } label: {
                            
                            SettingRow(
                                icon: "person",
                                title: "Personal Information"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                        
                        NavigationLink {
                            
                            EmptyView()
                            
                        } label: {
                            
                            SettingRow(
                                icon: "person.text.rectangle",
                                title: "Documents & Licenses"
                            )
                        }
                        .buttonStyle(.plain)
                        Divider()
                        
                        NavigationLink {
                            
                            EmptyView()
                            
                        } label: {
                            
                            SettingRow(
                                icon: "bell",
                                title: "Notification Settings"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                        
                        NavigationLink {
                            
                            EmptyView()
                            
                        } label: {
                            
                            SettingRow(
                                icon: "questionmark.circle",
                                title: "Support & Help"
                            )
                        }
                        .buttonStyle(.plain)
                        
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(
                        color: .black.opacity(0.04),
                        radius: 10,
                        x: 0,
                        y: 4
                    )
                }
                
                // MARK: - Logout
                
                Button {
                    
                } label: {
                    
                    Text("Log Out")
                        .font(.title3.bold())
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay {
                            
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.red.opacity(0.12))
                        }
                }
            }
            .padding()
            
            Spacer()
                .frame(height: 90)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}




#Preview {
    
    NavigationStack{
        DriverProfileView()
    }
    
}
