import SwiftUI

struct TripRowCard: View {
    var body: some View {
        HStack(spacing: 12) {
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .frame(width: 52, height: 52)
                
                Image(systemName: "clock")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color(.systemGray))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text("TRP-9904")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.blue)
                    
                    //                    Text("•")
                    //                        .foregroundStyle(.secondary)
                    //
                    //                    Text("Tomorrow")
                    //                        .font(.system(size: 15, weight: .medium))
                    //                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("Scheduled")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.orange.opacity(0.12))
                        .clipShape(Capsule())
                }
                
                Text("Delhi → Gurugram")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    
                    Text("12:55 AM")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            
            //            Spacer()
            //
            //            Image(systemName: "chevron.right")
            //                .font(.system(size: 15, weight: .semibold))
            //                .foregroundStyle(Color(.systemGray3))
        }
        .padding(16)
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
    ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        TripRowCard()
            .padding()
    }
}
