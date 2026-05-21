//
//  ReadyForTripsCard.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 21/05/26.
//



import SwiftUI

struct ReadyForTripsCard: View {

    @Binding var isReady: Bool

    var body: some View {
        HStack(spacing: 14) {

            // Icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 46, height: 46)
                Image(systemName: "person.fill.checkmark")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.blue)
            }

            // Labels
            VStack(alignment: .leading, spacing: 3) {
                Text("Ready for Trips")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)
                Text("Toggle to receive new assignments")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)

            }

            Spacer()

            Toggle("", isOn: $isReady)
                .labelsHidden()
                .tint(.blue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 0.5)
        )
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 4
        )
    }
}

#Preview {
    ReadyForTripsCard(isReady: .constant(true))
    
}
