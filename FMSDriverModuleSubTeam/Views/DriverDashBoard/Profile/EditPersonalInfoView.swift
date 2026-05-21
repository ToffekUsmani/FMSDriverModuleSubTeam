//
//  EditPersonalInfoView.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 22/05/26.
//


import SwiftUI

struct EditPersonalInfoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var driver: AppUser
    
    @State private var emergencyContact =
    "+91 87543 90690"
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 28) {
                
                // MARK: - Profile Image
                
                VStack(spacing: 16) {
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        Image(.driverSProfile)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        
                        Button {
                            
                        } label: {
                            
                            Image(systemName: "camera.fill")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                    
                    VStack(spacing: 4) {
                        
                        Text(driver.fullName)
                            .font(.title.bold())
                        
                        Text(driver.role.displayName)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 10)
                
                // MARK: - Form
                
                VStack(spacing: 18) {
                    
                    inputField(
                        title: "Full Name",
                        text: $driver.fullName
                    )
                    
                    inputField(
                        title: "Email Address",
                        text: .constant(driver.email)
                    )
                    
                    inputField(
                        title: "Phone Number",
                        text: Binding(
                            get: {
                                driver.phoneNumber ?? ""
                            },
                            set: {
                                driver.phoneNumber = $0
                            }
                        )
                    )
                    
                    inputField(
                        title: "Emergency Contact",
                        text: $emergencyContact
                    )
                }
                .padding(22)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .shadow(
                    color: .black.opacity(0.04),
                    radius: 10,
                    x: 0,
                    y: 4
                )
                
                // MARK: - Save Button
                
                Button {
                    
                    dismiss()
                    
                } label: {
                    
                    Text("Save Changes")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Input Field

extension EditPersonalInfoView {
    
    func inputField(
        title: String,
        text: Binding<String>
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            TextField(title, text: text)
                .font(.title3)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    
    NavigationStack {
        
        EditPersonalInfoView(
            driver: AppUser(
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
        )
    }
}