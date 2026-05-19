//
//  CuurentJobCard.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 19/05/26.
//

import SwiftUI

struct CuurentJobCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            RoundedRectangle(cornerRadius: 0)
                .fill( LinearGradient(colors: [ Color("F6C944").opacity(0.3),  Color("F6C944").opacity(0.08)], startPoint: .leading, endPoint: .trailing ))
                .frame(height: 6)
            //main content
            VStack(alignment: .leading, spacing: 16) {
                // Pickup
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                    
                    VStack(alignment: .leading, spacing: 2) {
                       Text("PICKUP")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.blue)
                            .tracking(0.5)
                        
                        Text("Agra")//Text(trip.startName ?? "Origin")
                            .font(.system(size: 15, weight: .semibold))
                        
                    }
                } //pickuo hstack
                
                // Delivery
                HStack(spacing: 10) {
                    Circle()
                        .fill(.green)
                        .frame(width: 10, height: 10)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("DELIVERY")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.green)
                            .tracking(0.5)
                        
                        Text("Delhi")//Text(trip.endName ?? "Destination")
                        
                    }
                } //delivery hstack
                
                Divider()
                
                // Time & Cargo row
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TIME")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .tracking(0.5)
                        
                        Text("Today, 4:30pm")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CARGO")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .tracking(0.5)
                        
                        Text("Automotive Components(4.6t)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }     // Time & Cargo row
                
                //buttons
                HStack(spacing: 10) {
                    
                    Button{
                        
                        
                    } label: {
                        Text("Start Job")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(.blue)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    
                    Button{
                        
                        
                    } label: {
                        Text("Details")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(.gray)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    
                }
            } //main content
        }
        .padding()
    }
}

#Preview {
    CuurentJobCard()
}
