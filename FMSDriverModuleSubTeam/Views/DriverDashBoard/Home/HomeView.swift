//
//  HomeView.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 19/05/26.
//

import SwiftUI

struct HomeView: View {
    @State var isAvailable: Bool = false
    var body: some View {
        
        NavigationStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    //name + profile
                    Spacer()
                    HStack{
                        VStack(alignment: .leading, spacing: 4){
                            Text("Hello, Toffek")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.primary)
                            
                            Text("Tuesday, 19 May")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Circle()
                                .fill(.gray.opacity(0.3))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: "person.crop.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.black)
                                )
                        }
                    } //name+profile
                    ReadyForTripsCard(isReady: $isAvailable)
                    //current or next trips(active trip panel)
                    VStack(alignment: .leading, spacing: 12) {
                        //section header
                        Text("Current Assignment")
                            .font(.system(size: 18, weight: .bold))
                        
                        CuurentJobCard()
                        
                        
                        
                        
                    } //active trip panel
                    
                    
                    // Upcoming Schedule Segment
                    VStack(alignment: .leading, spacing: 12) {
                        //section header
                        Text("Upcoming Trips")
                            .font(.system(size: 18, weight: .bold))
                        
                        TripRowCard()
                        
                        
                        //                    Text("No further trips assigned today")
                        //                        .font(.system(size: 14))
                        //                        .foregroundStyle(.secondary)
                        //                        .padding(.vertical, 8)
                    } //upcoming trip
                    
                    
                    //todays history
                    
                    VStack(alignment: .leading, spacing: 12) {
                        //section header
                        Text("Today's Summary")
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack(spacing: 12) {
                                    // Trips
                                    VStack(spacing: 10) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundStyle(.green)

                                        Text("2")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundStyle(.black)

                                        Text("Trips")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 130)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .fill(.white)
                                    )
                                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)

                                    // Distance
                                    VStack(spacing: 10) {
                                        Image(systemName: "road.lanes")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundStyle(.orange)

                                        Text("245.8 km")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundStyle(.black)

                                        Text("Distance")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 130)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .fill(.white)
                                    )
                                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)

                                    // Drive Time
                                    VStack(spacing: 10) {
                                        Image(systemName: "clock.fill")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundStyle(.blue)

                                        Text("3h 15m")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundStyle(.black)

                                        Text("Drive Time")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 130)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .fill(.white)
                                    )
                                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
                                }
                        
                    }
                } //main vstack
                
                
            } //main scrollView
            .padding(.horizontal)
            .scrollIndicators(.hidden)
            
        } //Navstack
    }
}

#Preview {
    HomeView()
}
