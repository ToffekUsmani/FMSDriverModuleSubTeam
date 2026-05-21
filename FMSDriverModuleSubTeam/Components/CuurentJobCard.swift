//
//  CuurentJobCard.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 19/05/26.

import SwiftUI

struct CuurentJobCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 16
            )
            .fill(LinearGradient(
                colors: [Color.blue.opacity(0.4), Color.blue.opacity(0.0)],
                startPoint: .leading,
                endPoint: .trailing
            ))
            .frame(height: 6)

            // Main content
            VStack(alignment: .leading, spacing: 16) {

                // Truck icon badge
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray5))  // Fix 5 — adaptive
                            .frame(width: 42, height: 42)
                        Image(systemName: "truck.box")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("VEHICLE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.secondary)
                            .tracking(0.5)
                        HStack(spacing: 6) {
                            Text("TX-9998")
                                .font(.system(size: 15, weight: .bold))
                            Text("•")
                                .foregroundStyle(.secondary)
                            Text("Volovo")
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    Spacer()
                }
                HStack(alignment: .top, spacing: 12) {

                    VStack(spacing: 0) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                            .padding(.top, 4)
                        Rectangle()
                            .fill(Color(.separator))
                            .frame(width: 1.5, height: 38)
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                            .padding(.bottom, 4)
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("PICKUP")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.blue)
                                .tracking(0.5)
                            Text("Agra")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("DELIVERY")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.green)
                                .tracking(0.5)
                            Text("Delhi")
                                .font(.system(size: 15, weight: .semibold))
                        }
                    }
                }

                Divider()

                // Time & Duration row
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("START TIME")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .tracking(0.5)
                        Text("Today, 4:30pm")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("DURATION")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .tracking(0.5)
                        Text("4h 40m")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Button
                Button {
                    
                } label: {
                    Label("Start Inspection", systemImage: "list.bullet.clipboard")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)

            }
            .padding(18)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        
    }
}

#Preview {
    CuurentJobCard()
}
